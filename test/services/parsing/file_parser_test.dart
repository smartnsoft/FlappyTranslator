import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';
import 'package:test/test.dart';

import '../../testing_utils.dart';

void main() {
  // test('Parameter file null triggers assertion', () {
  //   expect(
  //     () => _MockFileParser(file: null, startIndex: 1),
  //     throwsAssertionError,
  //   );
  // });

  // test('Parameter startIndex null triggers assertion', () {
  //   expect(
  //     () => _MockFileParser(file: File('example/test.csv'), startIndex: null),
  //     throwsAssertionError,
  //   );
  // });

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
    expect(parser.localizationsTable, [
      ['test', 'Hello, World!', 'Hallo, Welt!']
    ]);
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
