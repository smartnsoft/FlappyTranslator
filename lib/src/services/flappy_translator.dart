import 'dart:io';

import '../configs/constants.dart' as constants;
import '../configs/default_settings.dart';
import '../extensions/file_extensions.dart';
import '../utils/flappy_logger.dart';
import 'code_generation/code_generator.dart';
import 'file_writer/file_writer.dart';
import 'parsing/csv_parser.dart';
import 'parsing/excel_parser.dart';

class FlappyTranslator {
  void generate(
    String inputFilePath, {
    String outputDir,
    String fileName,
    String className,
    String delimiter,
    int startIndex,
    bool dependOnContext,
    bool useSingleQuotes,
    bool replaceNoBreakSpaces,
    bool exposeGetString,
    bool exposeLocaStrings,
    bool exposeLocaleMaps,
  }) async {
    // check that the file exists
    final file = File(inputFilePath);
    if (!file.existsSync()) {
      FlappyLogger.logError('File $inputFilePath does not exist!');
      return;
    }

    // check that the file has an extension - this is needed to determine if the file is supported
    if (!file.path.contains('.')) {
      FlappyLogger.logError('File $inputFilePath has no specified extension!');
      return;
    }

    // check that the file extension is correct
    if (!file.hasValidExtension) {
      FlappyLogger.logError(
        'File $inputFilePath has extension ${file.extensionType} which is not supported!',
      );
      return;
    }

    // File is valid, state progress
    FlappyLogger.logProgress('Loading file $inputFilePath...');

    // if null has been passed in, ensure that vars are given default values
    outputDir ??= DefaultSettings.outputDirectory;
    fileName ??= DefaultSettings.fileName;
    className ??= DefaultSettings.className;
    delimiter ??= DefaultSettings.delimiter;
    startIndex ??= DefaultSettings.startIndex;
    dependOnContext ??= DefaultSettings.dependOnContext;
    useSingleQuotes ??= DefaultSettings.useSingleQuotes;
    replaceNoBreakSpaces ??= DefaultSettings.replaceNoBreakSpaces;
    exposeGetString ??= DefaultSettings.exposeGetString;
    exposeLocaStrings ??= DefaultSettings.exposeLocaStrings;
    exposeLocaleMaps ??= DefaultSettings.exposeLocaleMaps;

    final codeGenerator = CodeGenerator(
      className: className,
      dependOnContext: dependOnContext,
      useSingleQuotes: useSingleQuotes,
      replaceNoBreakSpaces: replaceNoBreakSpaces,
      exposeGetString: exposeGetString,
      exposeLocaStrings: exposeGetString,
      exposeLocaleMaps: exposeLocaleMaps,
    );

    final parser = file.hasCSVExtension
        ? CSVParser(
            file: file,
            startIndex: startIndex,
            fieldDelimiter: delimiter,
          )
        : ExcelParser(file: file, startIndex: startIndex);

    final supportedLanguages = parser.supportedLanguages;
    codeGenerator.setSupportedLanguages(supportedLanguages);
    FlappyLogger.logProgress('Locales ${supportedLanguages} determined');

    final localizationsTable = parser.localizationsTable;
    FlappyLogger.logProgress('Parsing ${localizationsTable.length} keys...');

    final validateVariableNamesRegex = RegExp(r'^[a-z][a-zA-z0-9_]+$');

    for (final row in localizationsTable) {
      final key = row.first;
      final words = row.sublist(startIndex);
      if (words.length > supportedLanguages.length) {
        FlappyLogger.logError(
            'The row {$row} does not seems to be well formatted: (${words.length} words for ${supportedLanguages.length} columns)');
        return;
      }

      final defaultWord = words[0];
      if (defaultWord.isEmpty) {
        FlappyLogger.logError('$key has no translation for default language');
        return;
      }

      if (constants.reservedWords.contains(key)) {
        FlappyLogger.logError(
            '$key is a reserved keyword in Dart and cannot be used as key in row {$row}.\nAll reserved words in Dart are ${constants.reservedWords}');
        return;
      }

      if (!validateVariableNamesRegex.hasMatch(key)) {
        FlappyLogger.logError('$key is an invalid key.');
        return;
      }

      codeGenerator.addField(key, defaultWord, words);
    }

    codeGenerator.finalize();

    // format the contents according to dart defaults
    final formattedString = codeGenerator.formattedString;

    // write output file
    final path = outputDir == null || outputDir.isEmpty
        ? 'i18n.dart'
        : '$outputDir/$fileName.dart';
    FileWriter().write(contents: formattedString, path: path);

    FlappyLogger.logProgress('Localizations sucessfully generated!');
  }
}
