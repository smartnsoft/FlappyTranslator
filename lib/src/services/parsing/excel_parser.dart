import 'package:excel/excel.dart';

import 'file_parser.dart';

/// An extension of [FileParser] for files of type xlsx
class ExcelParser extends FileParser {
  ExcelParser({
    required super.file,
    required super.startIndex,
  });

  @override
  void parseFile() {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables.keys.first;

    if (excel.tables.containsKey(table)) {
      for (final row in excel.tables[table]!.rows) {
        final rowAsStrings =
            row.map((element) => element?.value?.toString() ?? '').toList();
        parsedContents.add(rowAsStrings);
      }
    }
  }
}
