import 'package:flappy_translator/flappy_translator.dart';
import 'package:test/test.dart';

import '../testing_utils.dart';

void main() {
  setTestingEnvironment();

  test('Generate with CSV file', () async {
    FlappyTranslator().generate('example/test.csv');
  });

  test('Generate with Excel file', () async {
    FlappyTranslator().generate('example/test.xlsx');
  });
}
