import 'dart:io';

import 'package:flappy_translator/src/services/parsing/file_parser.dart';

import '../../configs/constants.dart' as constants;
import '../../extensions/file_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../utils/flappy_logger.dart';

abstract class Validator {
  /// Validates whether [file] is valid
  ///
  /// If any error occurs, process is terminated
  static void validateFile(File file) {
    // check that the file exists
    if (!file.existsSync()) {
      FlappyLogger.logError('File ${file.path} does not exist!');
    }

    // check that the file extension is correct
    if (!file.hasValidExtension) {
      FlappyLogger.logError(
        'File ${file.path} has extension ${file.extensionType} which is not supported!',
      );
    }
  }

  /// Validates whether [supportedLanguages] are valid
  ///
  /// If any error occurs, process is terminated
  static void validateSupportedLanguages(List<String> supportedLanguages) {
    for (final supportedLanguage in supportedLanguages) {
      if (!supportedLanguage.isValidLocale) {
        FlappyLogger.logError(
            '$supportedLanguage isn\'t a valid locale. Expected locale of the form "en" or "en_US".');
      }

      final languageCode = supportedLanguage.split('_').first;
      if (!constants.flutterLocalizedLanguages.contains(languageCode)) {
        FlappyLogger.logWarning(
            '$languageCode isn\'t supported by default in Flutter.');
        FlappyLogger.logWarning(
            'Please see https://flutter.dev/docs/development/accessibility-and-localization/internationalization#adding-support-for-a-new-language for info on how to add required classes.');
      }
    }
  }

  /// Validates whether [localizationsTable] is valid
  ///
  /// If any error occurs, process is terminated
  static void validateLocalizationsTable(
      List<LocalizationTableRow> localizationsTable) {
    if (localizationsTable.isEmpty) {
      FlappyLogger.logError('No keys found.');
    }
  }

  /// Validates whether [row] is valid
  ///
  /// If any error occurs, process is terminated
  static void validateLocalizationTableRow(
    LocalizationTableRow row, {
    required int numberSupportedLanguages,
  }) {
    final key = row.key;
    if (constants.reservedWords.contains(key)) {
      FlappyLogger.logError(
          'Key $key in row ${row.raw} is a reserved keyword in Dart and is thus invalid.');
    }

    if (constants.types.contains(key)) {
      FlappyLogger.logError(
          'Key $key in row ${row.raw} is a type in Dart and is thus invalid.');
    }

    if (!key.isValidVariableName) {
      FlappyLogger.logError(
          'Key $key in row ${row.raw} is invalid. Expected key in the form lowerCamelCase.');
    }

    final words = row.words;
    if (words.length > numberSupportedLanguages) {
      FlappyLogger.logError(
          'The row ${row.raw} does not seem to be well formatted. Found ${words.length} values for numberSupportedLanguages locales.');
    }

    final defaultWord = row.defaultWord;
    if (defaultWord.isEmpty) {
      FlappyLogger.logError(
          'Key $key in row ${row.raw} has no translation for default language.');
    }
  }
}
