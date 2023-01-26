abstract class Template {
  static const begining = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: public_member_api_docs, prefer_single_quotes, avoid_escaping_inner_quotes, prefer_const_constructors, sort_constructors_first, always_specify_types, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/widgets.dart';

/// A class generated by flappy_translator package containing localized strings
class #CLASS_NAME# {
  /// Fields area

  static late Map<String, String> _localizedValues;

  /// Values area

''';

  static const String middleDependContext = '''
  #CLASS_NAME#(Locale locale) : _locale = locale {
    _localizedValues = {};
  }

  final Locale _locale;

  static #CLASS_NAME# of(BuildContext context) => 
    Localizations.of<#CLASS_NAME#>(context, #CLASS_NAME#)!;

  String _getText(String key) =>
    _localizedValues[key] ?? '** \$key not found';

  Locale get currentLocale => _locale;

  String get currentLanguage => _locale.languageCode;
''';

  static const middleDontDependContext = '''
  #CLASS_NAME#(Locale locale) {
    _locale = locale;
    _localizedValues = {};
  }

  static late Locale _locale;

  static String _getText(String key) =>
    _localizedValues[key] ?? '** \$key not found';

  static Locale get currentLocale => _locale;

  static String get currentLanguage => _locale.languageCode;
''';

  static String getString(bool dependOnContext) => '''

  /// Returns the corresponding string for a given key
  ${(dependOnContext ? '' : 'static ')}String getString(String key) => _getText(key);
''';

  static String locaStrings(bool dependOnContext) => '''

  /// Returns a map of key-locastring for the current locale
  /// 
  /// ```dart
  /// {
  ///   'test': 'Hello world!',
  /// }
  /// ```
  ${(dependOnContext ? '' : 'static ')}Map<String, String> get locaStrings => Map<String, String>.from(_localizedValues);
''';

  static String localeMaps(bool dependOnContext) => '''

  /// Returns a map of loca maps per locale
  /// 
  /// ```dart
  /// {
  ///   'en': {'test': 'Hello world!'},
  ///   'de': {'test': 'Hallo welt!'},
  /// }
  /// ```
  ${(dependOnContext ? '' : 'static ')}Map<String, Map<String, String>> get localeMaps {
    final returnMap = <String, Map<String, String>>{};
    _allValues.forEach(
      (key, value) => returnMap[key] = Map<String, String>.from(value),
    );
    return returnMap;
  }
''';

  static const String ending = '''

  static Future<#CLASS_NAME#> load(Locale locale) async {
    final translations = #CLASS_NAME#(locale);
    _localizedValues = _allValues[locale.toString()]!;
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

''';
}

abstract class TemplateKeys {
  static const className = '#CLASS_NAME#';
  static const valuesArea = '/// Values area';
  static const fieldsArea = '/// Fields area';
  static const supportedLanguagesArea = '/// SupportedLanguages area';
}
