import 'dart:io';

import 'package:flappy_translator/src/services/file_writer/file_writer.dart';
import 'package:test/test.dart';

void main() {
  test('write: null contents results in failure', () {
    final result = FileWriter().write(contents: null, path: '');
    expect(result, isFalse);
  });

  test('write: null path results in failure', () {
    final result = FileWriter().write(contents: '', path: null);
    expect(result, isFalse);
  });

  test('write: ensure written to disk', () async {
    final filepath = 'bla.text';
    final result = FileWriter().write(contents: 'Hello', path: filepath);
    expect(result, isTrue);
    expect(File(filepath).existsSync(), isTrue);

    await File(filepath).delete();
  });
}
