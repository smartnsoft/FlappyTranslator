import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';
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

    test('file does not have extension', () {
      tempFileHandler('test', (file) {
        Validator.validateFile(file);
      });
    }, skip: true);

    test('file not valid extension', () {
      tempFileHandler('test.txt', (file) {
        Validator.validateFile(file);
      });
    });
  });

  group('validateSupportedLanguages', () {
    test('locale is not valid', () {
      Validator.validateSupportedLanguages(['a']);
    });

    test('locale is not supported by default', () {
      Validator.validateSupportedLanguages(['ga']);
    });
  });

  group('validateLocalizationTableRow', () {
    test('key is reserved word', () {
      Validator.validateLocalizationTableRow(
        LocalizationTableRow(key: 'for', defaultWord: 'a', words: ['a'], raw: ['for', 'a']),
        numberSupportedLanguages: 1,
      );
    });

    test('key is type', () {
      Validator.validateLocalizationTableRow(
        LocalizationTableRow(key: 'int', defaultWord: 'a', words: ['a'], raw: ['int', 'a']),
        numberSupportedLanguages: 1,
      );
    });

    test('key is not valid variable name', () {
      Validator.validateLocalizationTableRow(
        LocalizationTableRow(key: 'MyKey', defaultWord: 'a', words: ['a'], raw: ['MyKey', 'a']),
        numberSupportedLanguages: 1,
      );
    });

    test('key is not valid variable name', () {
      Validator.validateLocalizationTableRow(
        LocalizationTableRow(key: 'MyKey', defaultWord: 'a', words: ['a', 'b'], raw: ['MyKey', 'a', 'b']),
        numberSupportedLanguages: 1,
      );
    });

    test('key is not valid variable name', () {
      Validator.validateLocalizationTableRow(
        LocalizationTableRow(key: 'MyKey', defaultWord: '', words: ['', 'b'], raw: ['MyKey', '', 'b']),
        numberSupportedLanguages: 2,
      );
    });
  });
}
