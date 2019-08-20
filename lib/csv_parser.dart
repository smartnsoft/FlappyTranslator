import 'file_parser.dart';

class CSVParser with FileParser {
  @override
  List<String> getSupportedLanguages(List<String> fileLines) {
    final List<String> languages = fileLines[0].split(",");
    return languages.sublist(1, languages.length);
  }

  @override
  List<String> getWordsOfLine(String line) {
    return line.split(",");
  }
}
