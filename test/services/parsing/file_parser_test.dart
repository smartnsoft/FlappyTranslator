import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';
import 'package:test/test.dart';

import '../../testing_utils.dart';

void main() {
  test('Parameter startIndex <= 0 triggers assertion', () {
    expect(
      () => _MockFileParser(file: File('example/test.csv'), startIndex: 0),
      throwsAssertionError,
    );
  });

  test('eraseParsedContents re-initializes parsedContents', () {
    final parser =
        _MockFileParser(file: File('example/test.csv'), startIndex: 1);
    parser.eraseParsedContents();
    expect(parser.parsedContents, []);
  });

  test('Ensure supportedLanguages, localizationsTable are correct', () {
    final parser =
        _MockFileParser(file: File('example/test.csv'), startIndex: 1);
    expect(parser.supportedLanguages, ['en', 'de']);
    final row = LocalizationTableRow(
      key: 'test',
      words: ['Hello, World!', 'Hallo, Welt!'],
      defaultWord: 'Hello, World!',
      raw: ['test', 'Hello, World!', 'Hallo, Welt!'],
    );
    expect(parser.localizationsTable.length, 1);
    expect(parser.localizationsTable.first.key, row.key);
    expect(parser.localizationsTable.first.words, row.words);
    expect(parser.localizationsTable.first.defaultWord, row.defaultWord);
    expect(parser.localizationsTable.first.raw, row.raw);
  });
}

class _MockFileParser extends FileParser {
  _MockFileParser({
    required File file,
    required int startIndex,
  }) : super(file: file, startIndex: startIndex);

  @override
  void parseFile() {
    parsedContents = [
      [
        'key',
        'en',
        'de',
      ],
      [
        'test',
        'Hello, World!',
        'Hallo, Welt!',
      ],
    ];
  }
}
