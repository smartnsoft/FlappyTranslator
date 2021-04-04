import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';
import 'package:test/test.dart';

import '../../testing_utils.dart';

void main() {
  late FileParser parser;

  setUp(() =>
      parser = _MockFileParser(file: File('example/test.csv'), startIndex: 1));

  test('Parameter startIndex <= 0 triggers assertion', () {
    expect(
      () => _MockFileParser(file: File('example/test.csv'), startIndex: 0),
      throwsAssertionError,
    );
  });

  test('eraseParsedContents re-initializes parsedContents', () {
    parser.eraseParsedContents();
    expect(parser.parsedContents, []);
  });

  test('supportedLanguages', () {
    expect(parser.supportedLanguages, ['en', 'de']);
  });

  test('localizationsTable', () {
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

  test('getColumn', () {
    expect(parser.getColumn(0), ['test']);
    expect(parser.getColumn(1), ['Hello, World!']);
    expect(parser.getColumn(2), ['Hallo, Welt!']);
  });

  test('keys', () {
    expect(parser.keys, ['test']);
  });

  test('getValues', () {
    expect(parser.getValues('en'), ['Hello, World!']);
    expect(parser.getValues('de'), ['Hallo, Welt!']);
  });

  test('defaultValues', () {
    expect(parser.defaultValues, ['Hello, World!']);
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
