library flappy_translator;

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'default_settings.dart';
import 'extensions/file_extensions.dart';
import 'flappy_logger.dart';
import 'parsing/csv_parser.dart';
import 'parsing/excel_parser.dart';
import 'template.dart';

const String CLASS_NAME_TEMPLATE_KEY = "#CLASS_NAME#";
const String VALUES_AREA_TEMPLATE_KEY = "/// Values area";
const String FIELDS_AREA_TEMPLATE_KEY = "/// Fields area";
const String SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY =
    "/// SupportedLanguages area";
const String PARAMETERS_REGEX = r"(\%[[0-9a-zA-Z]+]*\$(d|s))";
const List<String> RESERVED_WORDS = [
  "assert",
  "default",
  "finally",
  "rethrow",
  "try",
  "break",
  "do",
  "for",
  "return",
  "var",
  "case",
  "else",
  "if",
  "super",
  "void",
  "catch",
  "enum",
  "in",
  "switch",
  "while",
  "class",
  "extends",
  "is",
  "this",
  "with",
  "const",
  "false",
  "new",
  "throw",
  "continue",
  "final",
  "null",
  "true",
];
final RegExp validateVariableNamesRegexp = RegExp(r'^[a-z][a-zA-z0-9_]+$');

class FlappyTranslator {
  void generate(
    String inputFilePath, {
    String outputDir,
    String fileName,
    String className,
    String delimiter,
    int startIndex,
    bool dependOnContext,
    bool useSingleQuotes,
    bool replaceNoBreakSpaces,
    bool exposeGetString,
    bool exposeLocaStrings,
    bool exposeLocaleMaps,
  }) async {
    // check that the file exists
    final File file = File(inputFilePath);
    if (!file.existsSync()) {
      FlappyLogger.logError('File $inputFilePath does not exist!');
      return;
    }

    // check that the file has an extension - this is needed to determine if the file is supported
    if (!file.path.contains('.')) {
      FlappyLogger.logError('File $inputFilePath has no specified extension!');
      return;
    }

    // check that the file extension is correct
    if (!file.hasValidExtension) {
      FlappyLogger.logError(
        'File $inputFilePath has extension ${file.extensionType} which is not supported!',
      );
      return;
    }

    FlappyLogger.logProgress('Loading file $inputFilePath...');

    // if null has been passed in, ensure that vars are given default values
    outputDir ??= DefaultSettings.outputDirectory;
    fileName ??= DefaultSettings.fileName;
    className ??= DefaultSettings.className;
    delimiter ??= DefaultSettings.delimiter;
    startIndex ??= DefaultSettings.startIndex;
    dependOnContext ??= DefaultSettings.dependOnContext;
    useSingleQuotes ??= DefaultSettings.useSingleQuotes;
    replaceNoBreakSpaces ??= DefaultSettings.replaceNoBreakSpaces;
    exposeGetString ??= DefaultSettings.exposeGetString;
    exposeLocaStrings ??= DefaultSettings.exposeLocaStrings;
    exposeLocaleMaps ??= DefaultSettings.exposeLocaleMaps;

    // construct the template
    String template = templateBegining +
        (dependOnContext ? templateDependContext : templateDontDependContext) +
        (exposeGetString ? templateGetString(dependOnContext) : '') +
        (exposeLocaStrings ? templateLocaStrings(dependOnContext) : '') +
        (exposeLocaleMaps ? templateLocaleMaps(dependOnContext) : '') +
        templateEnding;
    template = template.replaceAll(CLASS_NAME_TEMPLATE_KEY, className);

    final parser = file.hasCSVExtension
        ? CSVParser(
            file: file,
            startIndex: startIndex,
            fieldDelimiter: delimiter,
          )
        : ExcelParser(file: file, startIndex: startIndex);

    final List<String> supportedLanguages = parser.supportedLanguages;
    final List<Map<String, String>> maps =
        _generateValuesMaps(supportedLanguages);
    template = _replaceSupportedLanguages(template, supportedLanguages);
    FlappyLogger.logProgress('Locales ${supportedLanguages} determined');

    final String quoteString = useSingleQuotes ? '\'' : '"';
    String fields = "";

    final localizationsTable = parser.localizationsTable;
    FlappyLogger.logProgress('Parsing ${localizationsTable.length} keys...');

    for (final row in localizationsTable) {
      final String key = row.first;
      final List<String> words = row.sublist(startIndex);
      if (words.length > supportedLanguages.length) {
        FlappyLogger.logError(
            "The row {$row} does not seems to be well formatted: (${words.length} words for ${supportedLanguages.length} columns)");
        return;
      }
      final String defaultWord = words[0];

      if (defaultWord.isEmpty) {
        FlappyLogger.logError("$key has no translation for default language");
        return;
      }

      if (_isKeyAReservedWord(key)) {
        FlappyLogger.logError(
            "$key is a reserved keyword in Dart and cannot be used as key in row {$row}.\nAll reserved words in Dart are : $RESERVED_WORDS");
        return;
      }

      if (!validateVariableNamesRegexp.hasMatch(key)) {
        FlappyLogger.logError("$key is an invalid key.");
        return;
      }

      fields += _addField(key, defaultWord,
          dependsOnContext: dependOnContext, quoteString: quoteString);

      maps[0][key] = defaultWord;
      for (int wordIndex = 1; wordIndex < words.length; wordIndex++) {
        maps[wordIndex][key] =
            words[wordIndex].isEmpty ? defaultWord : words[wordIndex];
      }
    }

    template = template.replaceAll(FIELDS_AREA_TEMPLATE_KEY, fields);
    template = template.replaceAll(
      VALUES_AREA_TEMPLATE_KEY,
      _generateStringValuesFromList(
        maps,
        supportedLanguages,
        quoteString: quoteString,
        replaceNoBreakSpaces: replaceNoBreakSpaces,
      ),
    );

    _writeInFile(template, outputDir, fileName);

    FlappyLogger.logProgress('Localizations sucessfully generated!');
  }

  void _writeInFile(String contents, String outputDir, String fileName) {
    // format the contents according to dart defaults
    contents = DartFormatter().format(contents);

    final File generatedFile = File(outputDir == null || outputDir.isEmpty
        ? 'i18n.dart'
        : '$outputDir/$fileName.dart');
    if (!generatedFile.existsSync()) {
      generatedFile.createSync(recursive: true);
    }
    generatedFile.writeAsStringSync(contents, mode: FileMode.write);
  }

  String _generateStringValuesFromList(
      List<Map<String, String>> maps, List<String> supportedLanguages,
      {String quoteString = '"', bool replaceNoBreakSpaces = false}) {
    final Map<String, Map<String, String>> allValuesMap = Map();
    final List<String> mapsNames = [];
    String result = "";

    for (int mapIndex = 0; mapIndex < maps.length; mapIndex++) {
      final String lang = supportedLanguages[mapIndex];
      final Map<String, String> map = maps[mapIndex];
      final String mapName = "_${lang.replaceAll("_", "")}Values";
      mapsNames.add(mapName);

      result += """
      static Map<String, String> $mapName = {
      """;

      map.forEach((key, value) {
        String formattedString = _formatString(value);
        if (quoteString == '\'') {
          formattedString = formattedString.replaceAll('\'', '\\\'');
          // incase the string already had \' then it will become \\\\\', replace this with \\\'
          formattedString = formattedString.replaceAll('\\\\\'', '\\\'');
        }
        if (replaceNoBreakSpaces) {
          formattedString = _replaceNoBreakSpaces(formattedString);
        }
        result += """
        $quoteString$key$quoteString: $quoteString$formattedString$quoteString,
        """;
      });

      result += "};\n\n";

      allValuesMap[lang] = map;
    }

    result += """
    static Map<String, Map<String, String>> _allValues = {
    """;

    supportedLanguages.asMap().forEach((index, lang) {
      result += """
        $quoteString$lang$quoteString: ${mapsNames[index]},
      """;
    });

    result += "};";

    return result;
  }

  String _formatString(String text) {
    text = text.replaceAll('"', '\\"');
    text = text.replaceAll('\$', '\\\$');

    return text;
  }

  String _replaceNoBreakSpaces(String text) {
    // sometimes there can be the strange '194 160' space, ie `no break space`. replace this with a normal space.
    text = text.replaceAll('\u00A0', ' ');
    text = text.replaceAll(' ', ' ');

    return text;
  }

  List<Map<String, String>> _generateValuesMaps(
      List<String> supportedLanguages) {
    final List<Map<String, String>> maps = [];
    supportedLanguages.forEach((supportedLanguage) => maps.add(Map()));
    return maps;
  }

  String _addField(String key, String defaultWord,
      {bool dependsOnContext = false, String quoteString = '"'}) {
    final RegExp regex = new RegExp(PARAMETERS_REGEX);
    final bool hasParameters = regex.hasMatch(defaultWord);
    if (hasParameters) {
      String parameters = "";
      final List<RegExpMatch> matches = regex.allMatches(defaultWord).toList();
      for (RegExpMatch match in matches) {
        final String parameterType = match.group(2) == "d" ? "int" : "String";
        parameters +=
            "@required $parameterType ${getParameterNameFromPlaceholder(match.group(0))}, ";
      }

      String result = (!dependsOnContext ? "static " : "") +
          """String $key({$parameters}) {
      String text = _getText($quoteString$key$quoteString);
      """;

      for (RegExpMatch match in matches) {
        final String placeholderName = _formatString(match.group(1));
        String varName = getParameterNameFromPlaceholder(match.group(0));
        result += """
        if ($varName != null) {
          text = text.replaceAll("$placeholderName", ${varName += match.group(2) == "d" ? ".toString()" : ""});
        }
        """;
      }

      return result +
          """
      return text;
      
      }
      """;
    }
    return (!dependsOnContext ? "static " : "") +
        """String get $key => _getText($quoteString$key$quoteString);\n\n""";
  }

  String getParameterNameFromPlaceholder(String placeholder) {
    String givenName = placeholder.substring(1, placeholder.length - 2);
    if (int.tryParse(givenName[0]) != null) {
      givenName = "var$givenName";
    }
    return givenName;
  }

  String _replaceSupportedLanguages(
      String template, List<String> supportedLanguages) {
    final StringBuffer languageLocals = StringBuffer();

    for (String lang in supportedLanguages) {
      languageLocals.write(createLocalConstructorFromLanguage(lang) + ',');
    }

    final String supportedLocals = """
    static final Set<Locale> supportedLocals = { $languageLocals };
    """
        .trim();

    return template.replaceAll(
      SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY,
      """
      $supportedLocals
      
      @override
      bool isSupported(Locale locale) => supportedLocals.contains(locale);
      """
          .trim(),
    );
  }

  String createLocalConstructorFromLanguage(String language) {
    final List<String> parts = language.split('_');
    return (parts.length == 1)
        ? """Locale('${parts[0]}')"""
        : """Locale('${parts[0]}', '${parts[1]}')""";
  }

  bool _isKeyAReservedWord(String key) {
    return RESERVED_WORDS.contains(key);
  }
}
