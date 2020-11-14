import 'package:flappy_translator/src/services/code_generation/template.dart';
import 'package:test/test.dart';

void main() {
  test('getString', () {
    expect(Template.getString(false), '''

  /// Returns the corresponding string for a given key
  static String getString(String key) => _getText(key);
''');

    expect(Template.getString(true), '''

  /// Returns the corresponding string for a given key
  String getString(String key) => _getText(key);
''');
  });

  test('locaStrings', () {
    expect(Template.locaStrings(false), '''

  /// Returns a map of key-locastring for the current locale
  /// 
  /// ```dart
  /// {
  ///   'test': 'Hello world!',
  /// }
  /// ```
  static Map<String, String> get locaStrings => Map<String, String>.from(_localizedValues);
''');

    expect(Template.locaStrings(true), '''

  /// Returns a map of key-locastring for the current locale
  /// 
  /// ```dart
  /// {
  ///   'test': 'Hello world!',
  /// }
  /// ```
  Map<String, String> get locaStrings => Map<String, String>.from(_localizedValues);
''');
  });

  test('localeMaps', () {
    expect(Template.localeMaps(false), '''

  /// Returns a map of loca maps per locale
  /// 
  /// ```dart
  /// {
  ///   'en': {'test': 'Hello world!'},
  ///   'de': {'test': 'Hallo welt!'},
  /// }
  /// ```
  static Map<String, Map<String, String>> get localeMaps {
    final returnMap = <String, Map<String, String>>{};
    _allValues.forEach(
      (key, value) => returnMap[key] = Map<String, String>.from(value),
    );
    return returnMap;
  }
''');

    expect(Template.localeMaps(true), '''

  /// Returns a map of loca maps per locale
  /// 
  /// ```dart
  /// {
  ///   'en': {'test': 'Hello world!'},
  ///   'de': {'test': 'Hallo welt!'},
  /// }
  /// ```
  Map<String, Map<String, String>> get localeMaps {
    final returnMap = <String, Map<String, String>>{};
    _allValues.forEach(
      (key, value) => returnMap[key] = Map<String, String>.from(value),
    );
    return returnMap;
  }
''');
  });
}
