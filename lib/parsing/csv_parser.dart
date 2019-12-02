import 'package:csv/csv.dart';
import 'package:meta/meta.dart';

import 'file_parser.dart';

class CSVParser with FileParser {
  final String fieldDelimiter;

  const CSVParser({@required this.fieldDelimiter});

  @override
  List<String> getSupportedLanguages(List<String> fileLines, {@required startIndex}) {
    final List<String> words = getWordsOfLine(fileLines.first);
    return words.sublist(startIndex, words.length);
  }

  @override
  List<String> getWordsOfLine(String line) {
    return CsvToListConverter()
        .convert(line, fieldDelimiter: fieldDelimiter)
        .first
        .map((element) => element.toString())
        .toList();
  }
}
