extension StringExtensions on String {
  static final _validLocaleRegex = RegExp(r'^[a-z]{2}(_[A-Z]{2})?$');

  bool get isValidLocale =>
      this != null ? _validLocaleRegex.hasMatch(this) : false;

  static final _validateVariableNamesRegex = RegExp(r'^[a-z][a-zA-z0-9_]*$');

  bool get isValidVariableName =>
      this != null ? _validateVariableNamesRegex.hasMatch(this) : false;
}
