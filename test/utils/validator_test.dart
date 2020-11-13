import 'package:flappy_translator/src/utils/validator.dart';
import 'package:test/test.dart';

void main() {
  test('isValidLocale', () {
    expect(Validator.isValidLocale('en'), isTrue);
    expect(Validator.isValidLocale('en_GB'), isTrue);
    expect(Validator.isValidLocale('en-GB'), isFalse);
    expect(Validator.isValidLocale('en-gb'), isFalse);
    expect(Validator.isValidLocale('en_gb'), isFalse);
    expect(Validator.isValidLocale('a_a'), isFalse);
    expect(Validator.isValidLocale('aa_bbb'), isFalse);
    expect(Validator.isValidLocale('12_34'), isFalse);
  });
}
