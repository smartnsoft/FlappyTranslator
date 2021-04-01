extension StringExtensions on String {
  static final _validLocaleRegex = RegExp(r'^[a-z]{2,3}(_[A-Z]{2})?$');

  /// Returns whether a locale pattern (i.e. en, en_GB) is valid.
  ///
  /// Note this does check if the locale exists, only if the pattern is correct.
  /// Thus zz_YY would return true although it is not a valid locale.
  bool get isValidLocale => _validLocaleRegex.hasMatch(this);

  static final _validateVariableNamesRegex = RegExp(r'^[a-z][a-zA-z0-9_]*$');

  /// Returns whether a variable name (i.e. myVar, my_var) is valid.
  bool get isValidVariableName => _validateVariableNamesRegex.hasMatch(this);
}
