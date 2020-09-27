import 'package:test/test.dart';

import '../../lib/src/extensions/file_extensions.dart';
import 'temp_file_handler.dart';

void main() {
  test('CSV file with valid extension', () {
    tempFileHandler('test.csv', (file) {
      expect(file.extensionType, 'csv');
      expect(file.hasValidExtension, true);
      expect(file.hasCSVExtension, true);
    });
  });

  test('CSV filepath in capitals', () {
    tempFileHandler('TEST.CSV', (file) {
      expect(file.extensionType, 'csv');
      expect(file.hasValidExtension, true);
      expect(file.hasCSVExtension, true);
    });
  });

  test('XLSX file with valid extension', () {
    tempFileHandler('test.xlsx', (file) {
      expect(file.extensionType, 'xlsx');
      expect(file.hasValidExtension, true);
      expect(file.hasCSVExtension, false);
    });
  });

  test('XLSX filepath in capitals', () {
    tempFileHandler('TEST.XLSX', (file) {
      expect(file.extensionType, 'xlsx');
      expect(file.hasValidExtension, true);
      expect(file.hasCSVExtension, false);
    });
  });
}
