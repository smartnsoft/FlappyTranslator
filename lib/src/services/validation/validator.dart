import 'dart:io';

import '../../extensions/file_extensions.dart';
import '../../utils/flappy_logger.dart';

abstract class Validator {
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
}
