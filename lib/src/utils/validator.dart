abstract class Validator {
  static final _validLocaleRegex = RegExp(r'^[a-z]{2}(_[A-Z]{2})?$');

  /// Returns whether a locale pattern (i.e. en, en_GB) is valid.
  ///
  /// Note this does check if the locale exists, only if the pattern is correct.
  /// Thus zz_YY would return true although it is not a valid locale.
  static bool isValidLocale(String locale) =>
      _validLocaleRegex.hasMatch(locale);
}
