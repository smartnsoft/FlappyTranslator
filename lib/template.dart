const String templateBegining = """
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: prefer_final_fields, public_member_api_docs, prefer_single_quotes, omit_local_variable_types, unnecessary_this

import 'dart:async';

import 'package:flutter/material.dart';

/// A  class generated by flappy_translator package containing localized strings
class #CLASS_NAME# {
  /// Fields area

  static Map<String, String> _localizedValues;

  /// Values area

""";

const String templateDependContext = """
  #CLASS_NAME#(Locale locale) {
    this._locale = locale;
    _localizedValues = null;
  }

  Locale _locale;

  static #CLASS_NAME# of(BuildContext context) {
    return Localizations.of<#CLASS_NAME#>(context, #CLASS_NAME#);
  }

  String _getText(String key) {
    return _localizedValues[key] ?? '** \$key not found';
  }

  Locale get currentLocale => _locale;

  String get currentLanguage => _locale.languageCode;
""";

const String templateDontDependContext = """
  #CLASS_NAME#(Locale locale) {
    _locale = locale;
    _localizedValues = null;
  }

  static Locale _locale;

  static String _getText(String key) {
    return _localizedValues[key] ?? '** \$key not found';
  }

  static Locale get currentLocale => _locale;

  static String get currentLanguage => _locale.languageCode;
""";

String templateGetString(bool dependOnContext) =>
    """

  /// Returns the corresponding string for a given key
""" +
    (dependOnContext ? "" : "static ") +
    """
  String getString(String key) => _getText(key);
""";

String templateLocaStrings(bool dependOnContext) =>
    """

  /// Returns a map of key-locastring for the current locale
  /// 
  /// ```dart
  /// {
  ///   'test': 'Hello world!',
  /// }
  /// ```
""" +
    (dependOnContext ? "" : "static ") +
    """
  Map<String, String> get locaStrings => Map<String, String>.from(_localizedValues);
""";

String templateLocaleMaps(bool dependOnContext) =>
    """

  /// Returns a map of loca maps per locale
  /// 
  /// ```dart
  /// {
  ///   'en': {'test': 'Hello world!'},
  ///   'de': {'test': 'Hallo welt!'},
  /// }
  /// ```
""" +
    (dependOnContext ? "" : "static ") +
    """
  Map<String, Map<String, String>> get localeMaps {
    final returnMap = <String, Map<String, String>>{};
    _allValues.forEach(
      (key, value) => returnMap[key] = Map<String, String>.from(value),
    );
    return returnMap;
  }
""";

const String templateEnding = """

  static Future<#CLASS_NAME#> load(Locale locale) async {
    final translations = #CLASS_NAME#(locale);
    _localizedValues = _allValues[locale.toString()];
    return translations;
  }
}

class #CLASS_NAME#Delegate extends LocalizationsDelegate<#CLASS_NAME#> {
  const #CLASS_NAME#Delegate();

  /// SupportedLanguages area

  @override
  Future<#CLASS_NAME#> load(Locale locale) => #CLASS_NAME#.load(locale);

  @override
  bool shouldReload(#CLASS_NAME#Delegate old) => false;
}

""";
