import 'dart:io';

import '../enums/supported_input_file_type.dart';

extension FileExtensions on File {
  String get extensionType => path.split('.').last.toLowerCase();

  bool get hasValidExtension => SupportedInputFileType.values
      .map((value) => _describeEnum(value))
      .contains(extensionType);

  bool get hasCSVExtension => extensionType == 'csv';
}

/// Taken from flutter
String _describeEnum(Object enumEntry) {
  final description = enumEntry.toString();
  final indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
