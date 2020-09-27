import 'dart:io';

import 'package:flappy_translator/flappy_logger.dart';
import 'package:meta/meta.dart';

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
  List<List<String>> parsedContents;

  FileParser({
    @required this.file,
    @required this.startIndex,
  })  : assert(file != null),
        assert(startIndex != null),
        assert(startIndex > 0) {
    eraseParsedContents();
    parseFile();
  }

  /// Erases all parsed content
  @protected
  void eraseParsedContents() => parsedContents = <List<String>>[];

  /// Parses the file. All base classes must implement this method.
  @protected
  void parseFile();

  /// Returns the localized languages (i.e. fr, en_GB)
  List<String> get supportedLanguages {
    if (parsedContents != null && parsedContents.isNotEmpty) {
      return parsedContents.first.sublist(startIndex);
    }

    FlappyLogger.logError('Error! File contents have not been parsed.');
    return null;
  }

  /// Returns a table of localizations (excluding supported languages)
  List<List<String>> get localizationsTable {
    if (parsedContents != null && parsedContents.isNotEmpty) {
      return parsedContents.sublist(_numberHeaderLines);
    }

    FlappyLogger.logError('Error! File contents have not been parsed.');
    return null;
  }
}
