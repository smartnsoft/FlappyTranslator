import 'dart:io';

import 'package:flappy_translator/src/services/parsing/excel_parser.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_single_quotes
void main() {
  test('parseFile', () {
    final parser = ExcelParser(file: File('example/test.xlsx'), startIndex: 1);
    expect(parser.supportedLanguages, ['fr', 'en', 'es', 'de_CH']);
    expect(parser.localizationsTable, [
      [
        'appTitle',
        'Ma super application',
        'My awesome application',
        'Mi gran application',
        'Meine tolle App'
      ],
      [
        'subtitle',
        'Un sous titre',
        'A subtitle',
        'Un subtitulò',
        'Ein Untertitel'
      ],
      [
        'description',
        'Un texte avec une variable : %1\$s',
        'Text with a variable: %1\$s',
        'Un texto con una variable : %1\$s',
        'Text mit einer Variable: %1\$s'
      ],
      [
        "littleTest",
        "Voici, pour l'exemple, \"un test\" avec la variable %age\$d",
        "Here is, for the example, \"a test\" with the variable %age\$d",
        "Aqui esta, por ejemplo, \"una prueba\" con la variable %age\$d",
        "Hier ist, zum Beispiel, \"ein Test\" mit der Variable %age\$d"
      ],
    ]);
  });
}
