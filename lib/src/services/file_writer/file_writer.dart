import 'dart:io';

class FileWriter {
  bool write({
    required String? contents,
    required String? path,
  }) {
    if (contents != null && path != null) {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(contents);

      return true;
    }

    return false;
  }
}
