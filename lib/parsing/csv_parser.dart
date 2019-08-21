import 'package:csv/csv.dart';

import 'file_parser.dart';

class CSVParser with FileParser {
  static const String DELIMITER = ",";

  @override
  List<String> getSupportedLanguages(List<String> fileLines) {
    final List<String> words = getWordsOfLine(fileLines.first);
    return words.sublist(1, words.length);
  }

  @override
  List<String> getWordsOfLine(String line) {
    return CsvToListConverter().convert(line).first.map((element) => element.toString()).toList();
  }
}
