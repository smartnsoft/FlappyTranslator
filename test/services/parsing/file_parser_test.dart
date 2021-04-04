import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';
import 'package:test/test.dart';

import '../../testing_utils.dart';

void main() {
  setTestingEnvironment();

  late FileParser parser;

  setUp(() => parser = _MockFileParser(file: File('example/test.csv'), startIndex: 1));

  test('Parameter startIndex <= 0 triggers assertion', () {
    expect(
      () => _MockFileParser(file: File('example/test.csv'), startIndex: 0),
      throwsAssertionError,
    );
  });

  test('eraseParsedContents re-initializes parsedContents', () {
    parser.eraseParsedContents();
    expect(parser.parsedContents, isEmpty);
  });

  test('supportedLanguages', () {
    expect(parser.supportedLanguages, ['en', 'de']);
  });

  test('supportedLanguages exits when contents are not parsed', () {
    parser.eraseParsedContents();
    expect(
      () => parser.supportedLanguages,
      // as exit(0) is disabled in test, a bad state instead would occur
      throwsStateError,
    );
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

  test('localizationsTable exits when contents are not parsed', () {
    parser.eraseParsedContents();
    expect(
      () => parser.localizationsTable,
      // as exit(0) is disabled in test, a RangeError instead would occur
      throwsA(isA<RangeError>()),
    );
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

  test('getValues exits when language is not valid', () {
    expect(
      () => parser.getValues('pl'),
      // as exit(0) is disabled in test, a RangeError instead would occur
      throwsA(isA<RangeError>()),
    );
  });

  test('defaultValues', () {
    expect(parser.defaultValues, ['Hello, World!']);
  });

  test('LocalizationTableRow.toString', () {
    final row = LocalizationTableRow(key: 'myKey', defaultWord: 'a', words: ['a', 'b'], raw: ['myKey', 'a', 'b']);
    expect(
      row.toString(),
      isNot('Instance of \'LocalizationTableRow\''),
    );
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
