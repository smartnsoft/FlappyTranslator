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
  List<List<String>> get localizationsTable {
    if (parsedContents.isEmpty) {
      FlappyLogger.logError('Error! File contents have not been parsed.');
    }

    return parsedContents.sublist(_numberHeaderLines);
  }
}
