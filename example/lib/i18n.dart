import 'dart:async';

import 'package:flutter/material.dart';

class I18n {
  static String app_title(BuildContext context) => _text("app_title", context);static String subtitle(BuildContext context) => _text("subtitle", context);

  static String _text(String key, BuildContext context) => Localizations.of<I18n>(context, I18n).text(key);

  I18n(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;

  static Map<String, String> _localizedValues;

  static Map<String, String> _frValues = {
              "app_title": "Un titre",
                "subtitle": "Un sous titre",
        };
      
static Map<String, String> _enValues = {
              "app_title": "A title",
                "subtitle": "Un sous-titre",
        };
    static Map<String, Map<String, String>> _allValues = {
            "fr": _frValues,
              "en": _enValues,
      };

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<I18n> load(Locale locale) async {
    I18n translations = new I18n(locale);
    _localizedValues = _allValues[locale.languageCode];
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<I18n> {
  const TranslationsDelegate();

  @override
      bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
