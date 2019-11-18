library flappy_translator;

import 'dart:io';

import 'flappy_logger.dart';
import 'parsing/csv_parser.dart';
import 'parsing/file_parser.dart';
import 'template.dart';

const String VALUES_AREA_TEMPLATE_KEY = "/// Values area";
const String FIELDS_AREA_TEMPLATE_KEY = "/// Fields area";
const String SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY = "/// SupportedLanguages area";
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

class FlappyTranslator {
  void generate(String filePath, {String targetPath = ""}) async {
    final File file = File(filePath);

    if (!file.existsSync()) {
      FlappyLogger.logError("File $filePath does not exist");
      return;
    }

    String template = templateString;

    final FileParser fileParser = CSVParser();

    final lines = file.readAsLinesSync();

    final List<String> supportedLanguages = fileParser.getSupportedLanguages(lines);
    final List<Map<String, String>> maps = _generateValuesMaps(supportedLanguages);
    template = _replaceSupportedLanguages(template, supportedLanguages);

    String fields = "";
    FlappyLogger.logProgress("${lines.length - 1} words recognized");

    for (var linesIndex = 1; linesIndex < lines.length; linesIndex++) {
      final List<String> wordsOfLine = fileParser.getWordsOfLine(lines[linesIndex]);
      final String key = wordsOfLine.first;
      final words = wordsOfLine.sublist(1, wordsOfLine.length);
      if (words.length > supportedLanguages.length) {
        FlappyLogger.logError(
            "The line number ${linesIndex + 1} seems to be not well formatted (${words.length} words for ${supportedLanguages.length} columns)");
        return;
      }
      final String defaultWord = words[0];

      if (defaultWord.isEmpty) {
        FlappyLogger.logError("$key has no translation for default language");
        return;
      }

      if (_isKeyAReservedWord(key)) {
        FlappyLogger.logError(
            "$key is a reserved keyword in Dart and cannot be used as key (line ${linesIndex + 1})\nAll reserved words in Dart are : $RESERVED_WORDS");
        return;
      }
      fields += _addField(key, defaultWord);

      maps[0][key] = defaultWord;
      for (var wordIndex = 1; wordIndex < words.length; wordIndex++) {
        maps[wordIndex][key] = words[wordIndex].isEmpty ? defaultWord : words[wordIndex];
      }
    }

    template = template.replaceAll(FIELDS_AREA_TEMPLATE_KEY, fields);
    template = template.replaceAll(VALUES_AREA_TEMPLATE_KEY, _generateStringValuesFromList(maps, supportedLanguages));

    _writeInFile(template, targetPath);

    FlappyLogger.logProgress("End of work !");
  }

  void _writeInFile(String template, String targetPath) {
    if (targetPath != null) {
      if (!Directory(targetPath).existsSync()) {
        Directory(targetPath).createSync(recursive: true);
      }
    }
    final File generatedFile = File(targetPath != null ? "$targetPath/i18n.dart" : "i18n.dart");
    generatedFile.createSync();

    generatedFile.writeAsStringSync(template, mode: FileMode.write);
  }

  String _generateStringValuesFromList(List<Map<String, String>> maps, List<String> supportedLanguages) {
    final Map<String, Map<String, String>> allValuesMap = Map();
    final List<String> mapsNames = [];
    String result = "";

    for (var mapIndex = 0; mapIndex < maps.length; mapIndex++) {
      final String lang = supportedLanguages[mapIndex];
      final Map<String, String> map = maps[mapIndex];
      final String mapName = "_${lang}Values";
      mapsNames.add(mapName);

      result += """
      \nstatic Map<String, String> $mapName = {
      """;

      map.forEach((key, value) {
        result += """
        "$key": "${_formatString(value)}",
        """;
      });

      result += "};\n";

      allValuesMap[lang] = map;
    }

    result += """
    static Map<String, Map<String, String>> _allValues = {
    """;

    supportedLanguages.asMap().forEach((index, lang) {
      result += """
        "$lang": ${mapsNames[index]},
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

  List<Map<String, String>> _generateValuesMaps(List<String> supportedLanguages) {
    final List<Map<String, String>> maps = [];
    supportedLanguages.forEach((supportedLanguage) => maps.add(Map()));
    return maps;
  }

  String _addField(String key, String defaultWord) {
    final RegExp regex = new RegExp(PARAMETERS_REGEX);
    final bool hasParameters = regex.hasMatch(defaultWord);
    if (hasParameters) {
      String parameters = "";
      final List<RegExpMatch> matches = regex.allMatches(defaultWord).toList();
      for (RegExpMatch match in matches) {
        final String parameterType = match.group(2) == "d" ? "int" : "String";
        parameters += "@required $parameterType ${getParameterNameFromPlaceholder(match.group(0))}, ";
      }

      String result = """String $key({$parameters}) {
      String text = _getText("$key");
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
    return """String get $key => _getText("$key");\n\n""";
  }

  String getParameterNameFromPlaceholder(String placeholder) {
    String givenName = placeholder.substring(1, placeholder.length - 2);
    if (int.tryParse(givenName[0]) != null) {
      givenName = "var$givenName";
    }
    return givenName;
  }

  String _replaceSupportedLanguages(String template, List<String> supportedLanguages) {
    final StringBuffer languageLocals = StringBuffer();

    for (var lang in supportedLanguages) {
      languageLocals.write(createLocalConstructorFromLanguage(lang) + ',');
    }

    final supportedLocals =
    """
    static final Set<Locale> supportedLocals = { $languageLocals };
    """.trim();

    return template.replaceAll(
      SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY,
      """
      $supportedLocals
      
      @override
      bool isSupported(Locale locale) => supportedLocals.contains(locale);
      """.trim(),
    );
  }

  String createLocalConstructorFromLanguage(String language) {
    final parts = language.split('_');
    return (parts.length == 1)
        ? """Locale('${parts[0]}')"""
        : """Locale('${parts[0]}', '${parts[1]}')""";
  }

  bool _isKeyAReservedWord(String key) {
    return RESERVED_WORDS.contains(key);
  }
}
