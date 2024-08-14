import 'package:csv/csv.dart';

import 'file_parser.dart';

/// An extension of [FileParser] for files of type csv
class CSVParser extends FileParser {
  /// The delimiter to separate fields (i.e. `,` or `;`)
  final String fieldDelimiter;

  final CsvToListConverter _csvConverter = CsvToListConverter();

  CSVParser({
    required super.file,
    required super.startIndex,
    required this.fieldDelimiter,
  });

  @override
  void parseFile() {
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final lineElements = _csvConverter
          .convert(line, fieldDelimiter: fieldDelimiter)
          .first
          .map((element) => element.toString())
          .toList();

      parsedContents.add(lineElements);
    }
  }
}
