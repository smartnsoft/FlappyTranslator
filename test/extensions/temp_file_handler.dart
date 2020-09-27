import 'dart:io';

void tempFileHandler(String filename, void Function(File) body) {
  final file = File(filename);
  file.writeAsStringSync('');

  body(file);

  file.deleteSync();
}
