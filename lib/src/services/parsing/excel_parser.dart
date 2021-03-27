import 'dart:io';

import 'package:excel/excel.dart';

import 'file_parser.dart';

/// An extension of [FileParser] for files of type xlsx
class ExcelParser extends FileParser {
  ExcelParser({
    required File file,
    required int startIndex,
  }) : super(file: file, startIndex: startIndex);

  @override
  void parseFile() {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables.keys.first;

    for (final row in excel.tables[table]!.rows) {
      final rowAsStrings = row.map((element) => element.toString()).toList();
      parsedContents.add(rowAsStrings);
    }
  }
}
