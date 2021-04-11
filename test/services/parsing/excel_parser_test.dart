import 'dart:io';

import 'package:flappy_translator/src/services/parsing/excel_parser.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_single_quotes
void main() {
  test('parseFile', () {
    final parser = ExcelParser(file: File('example/test.xlsx'), startIndex: 1);
    expect(parser.supportedLanguages, ['fr', 'en', 'en_GB', 'de']);
    expect(parser.localizationsTable.map((row) => row.raw), [
      [
        'plainText',
        'Bonjour le monde!',
        'Hello world!',
        'Hello world!',
        'Hallo Welt!',
      ],
      [
        'welcome',
        'Bienvenu %name\$s!',
        'Welcome %name\$s!',
        'Welcome %name\$s!',
        'Willkommen %name\$s!',
      ],
      [
        'favoriteColor',
        'Quelle est votre couleur préférée?',
        'What is your favorite color?',
        'What is your favourite colour?',
        'Was ist deine Lieblingsfarbe?',
      ],
    ]);
  });
}
