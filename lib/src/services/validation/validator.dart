import 'dart:io';

import '../../configs/constants.dart' as constants;
import '../../extensions/file_extensions.dart';
import '../../extensions/string_extensions.dart';
import '../../utils/flappy_logger.dart';

abstract class Validator {
  /// Validates whether [file] is valid
  ///
  /// If any error occurs, process is derminated
  static void validateFile(File file) {
    // check that the file exists
    if (!file.existsSync()) {
      FlappyLogger.logError('File ${file.path} does not exist!');
    }

    // check that the file has an extension - this is needed to determine if the file is supported
    if (!file.path.contains('.')) {
      FlappyLogger.logError('File ${file.path} has no specified extension!');
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
  /// If any error occurs, process is derminated
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
}
