import 'dart:io';

import 'package:flappy_translator/flappy_translator.dart';
import 'package:test/test.dart';

import '../testing_utils.dart';

void main() async {
  setTestingEnvironment();

  test('Generate with CSV file', () {
    FlappyTranslator().generate('example/test.csv');
  });

  test('Generate with Excel file', () {
    FlappyTranslator().generate('example/test.xlsx');
  });

  await Future.delayed(Duration(seconds: 4));

  test('Ensure cleanup', () {
    final file = File('lib/i18n.dart');
    expect(file.existsSync(), isTrue);
    File('lib/i18n.dart').deleteSync();
    expect(file.existsSync(), isFalse);
  });
}
