import 'dart:io';

import 'package:flappy_translator/src/services/validation/validator.dart';
import 'package:test/test.dart';

import '../../extensions/temp_file_handler.dart';
import '../../testing_utils.dart';

void main() {
  setTestingEnvironment();

  group('validateFile', () {
    test('file does not exist', () {
      Validator.validateFile(File('bla.csv'));
    });

    test('file not valid extension', () {
      tempFileHandler('test.txt', (file) {
        Validator.validateFile(file);
      });
    });
  });

  group('', () {
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
  });
}
