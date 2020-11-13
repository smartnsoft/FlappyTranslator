import 'package:flappy_translator/src/extensions/string_extensions.dart';
import 'package:test/test.dart';

void main() {
  test('isValidLocale', () {
    expect('en'.isValidLocale, isTrue);
    expect('en_GB'.isValidLocale, isTrue);
    expect('en-GB'.isValidLocale, isFalse);
    expect('en-gb'.isValidLocale, isFalse);
    expect('en_gb'.isValidLocale, isFalse);
    expect('a_a'.isValidLocale, isFalse);
    expect('aa_bbb'.isValidLocale, isFalse);
    expect('12_34'.isValidLocale, isFalse);
  });
}
