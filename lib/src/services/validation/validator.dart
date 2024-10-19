import 'dart:io';

import '../../utils/flappy_logger.dart';

// Override the supported file types from arb_generator

/// An enum describing the types of supported input file types
enum SupportedInputFileType {
  /// The csv file type
  csv,

  /// The xlsx file type
  xlsx,
}

extension FileExtensions on File {
  String get extensionType => path.split('.').last.toLowerCase();

  bool get hasValidExtension => SupportedInputFileType.values
      .map((value) => value.name)
      .contains(extensionType);

  bool get hasCSVExtension => extensionType == 'csv';
}

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
}
