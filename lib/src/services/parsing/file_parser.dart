import 'dart:io';

import 'package:meta/meta.dart';

import '../../utils/flappy_logger.dart';

/// A base file parser which should be extended by supported file times
abstract class FileParser {
  /// The number of header lines (ie rows) before localizations start
  static const int _numberHeaderLines = 1;

  /// The file to parse
  final File file;

  /// The (column) index where localizations start
  final int startIndex;

  /// A 2D list of parsed localizations
  @protected
  @visibleForTesting
  late List<List<String>> parsedContents;

  FileParser({
    required this.file,
    required this.startIndex,
  }) : assert(startIndex > 0) {
    eraseParsedContents();
    parseFile();
  }

  /// Erases all parsed content
  @protected
  @visibleForTesting
  void eraseParsedContents() => parsedContents = <List<String>>[];

  /// Parses the file. All base classes must implement this method.
  @protected
  void parseFile();

  /// Returns the localized languages (i.e. fr, en_GB)
  List<String> get supportedLanguages {
    if (parsedContents.isEmpty) {
      FlappyLogger.logError('Error! File contents have not been parsed.');
    }

    return parsedContents.first.sublist(startIndex);
  }

  /// Returns a table of localizations (excluding supported languages)
  List<LocalizationTableRow> get localizationsTable {
    if (parsedContents.isEmpty) {
      FlappyLogger.logError('Error! File contents have not been parsed.');
    }

    final locaTable = parsedContents.sublist(_numberHeaderLines);
    return locaTable
        .map(
          (row) => LocalizationTableRow(
            key: row.first,
            // if there is not a default word, use key
            defaultWord: row.sublist(startIndex).isNotEmpty &&
                    row.sublist(startIndex).first.isNotEmpty
                ? row.sublist(startIndex).first
                : row.first,
            words: row.sublist(startIndex),
            raw: row,
          ),
        )
        .toList(growable: false);
  }

  /// Returns a column from localizations table
  List<String> getColumn(int index) => parsedContents
      .sublist(_numberHeaderLines)
      .map((row) => row[index])
      .toList(growable: false);

  /// Returns all localization keys
  List<String> get keys => getColumn(0);

  /// Returns all localizations values for a language
  List<String> getValues(String language) {
    if (!supportedLanguages.contains(language)) {
      FlappyLogger.logError(
          'Error! Language $language is not part of parsed contents.');
    }

    return getColumn(parsedContents.first.indexOf(language));
  }

  /// Returns all localizations values for the default language
  List<String> get defaultValues => getColumn(startIndex);
}

/// A model representing a row in a [LocalizationTable]
class LocalizationTableRow {
  /// The localization key
  final String key;

  /// The default word (i.e. value for default language)
  final String defaultWord;

  /// All translations
  final List<String> words;

  /// The raw content
  final List<String> raw;

  const LocalizationTableRow({
    required this.key,
    required this.defaultWord,
    required this.words,
    required this.raw,
  });

  @override
  bool operator ==(other) =>
      other is LocalizationTableRow &&
      key == other.key &&
      defaultWord == other.defaultWord &&
      _listEquals(words, other.words) &&
      _listEquals(raw, other.raw);

  @override
  int get hashCode => raw.hashCode;

  @override
  String toString() =>
      '{key: $key, defaultWord: $defaultWord, words: $words, raw: $raw}';
}

/// Compares two lists for deep equality.
/// Returns true if the lists are both null, or if they are both non-null, have the same length, and contain the same members in the same order. Returns false otherwise.
///
/// The term "deep" above refers to the first level of equality: if the elements are maps, lists, sets, or other collections/composite objects, then the values of those elements are not compared element by element unless their equality operators (Object.==) do so.
///
/// Taken from Flutter foundation https://api.flutter.dev/flutter/foundation/listEquals.html
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}
