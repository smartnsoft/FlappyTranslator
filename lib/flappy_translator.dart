library flappy_translator;

import 'dart:io';

import 'csv_parser.dart';
import 'file_parser.dart';
import 'flappy_logger.dart';

const String VALUES_AREA_TEMPLATE_KEY = "/// Values area";
const String FIELDS_AREA_TEMPLATE_KEY = "/// Fields area";
const String SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY = "/// SupportedLanguages area";

class FlappyTranslator {
  void generate(String filePath) async {
    final File file = File(filePath);

    if (!file.existsSync()) {
      FlappyLogger.logError("File $filePath does not exist");
      return;
    }

    final File templateFile = File("../lib/i18n.txt");
    String template = templateFile.readAsStringSync();

    final FileParser fileParser = CSVParser();

    final lines = file.readAsLinesSync();

    final List<String> supportedLanguages = fileParser.getSupportedLanguages(lines);
    final List<Map<String, String>> maps = _generateValuesMaps(supportedLanguages);
    template = replaceSupportedLanguages(template, supportedLanguages);

    String fields = "";
    FlappyLogger.logProgress("${lines.length - 1} words recognized");

    for (var linesIndex = 1; linesIndex < lines.length; linesIndex++) {
      final List<String> wordsOfLine = fileParser.getWordsOfLine(lines[linesIndex]);
      final String key = wordsOfLine.first;
      final words = wordsOfLine.sublist(1, wordsOfLine.length);
      fields += _addField(fields, key);

      for (var wordIndex = 0; wordIndex < words.length; wordIndex++) {
        maps[wordIndex][key] = words[wordIndex];
      }
    }

    template = template.replaceAll(FIELDS_AREA_TEMPLATE_KEY, fields);
    template = template.replaceAll(VALUES_AREA_TEMPLATE_KEY, _generateStringValuesFromList(maps, supportedLanguages));

    final File generatedFile = File("i18n.dart");
    generatedFile.createSync();

    generatedFile.writeAsStringSync(template, mode: FileMode.write);
    FlappyLogger.logProgress("Everything worked well !");
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
        "$key": "$value",
        """;
      });

      result += "};\n";

      allValuesMap[lang] = maps[mapIndex];
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

    return result.trim();
  }

  List<Map<String, String>> _generateValuesMaps(List<String> supportedLanguages) {
    final List<Map<String, String>> maps = [];
    supportedLanguages.forEach((supportedLanguage) => maps.add(Map()));
    return maps;
  }

  String _addField(String fields, String key) {
    return """static String $key(BuildContext context) => _text("$key", context);\n""".trim();
  }

  static String replaceSupportedLanguages(String template, List<String> supportedLanguages) {
    return template.replaceAll(
      SUPPORTED_LANGUAGES_AREA_TEMPLATE_KEY,
      """
      @override
      bool isSupported(Locale locale) => ${supportedLanguages.map((e) => "'$e'").toList()}.contains(locale.languageCode);
      """
          .trim(),
    );
  }
}
