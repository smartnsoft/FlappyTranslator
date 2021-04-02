import 'dart:io';

import '../configs/constants.dart' as constants;
import '../configs/default_settings.dart';
import '../extensions/file_extensions.dart';
import '../extensions/string_extensions.dart';
import '../utils/flappy_logger.dart';
import 'code_generation/code_generator.dart';
import 'file_writer/file_writer.dart';
import 'parsing/csv_parser.dart';
import 'parsing/excel_parser.dart';

class FlappyTranslator {
  void generate(
    String inputFilePath, {
    String? outputDir,
    String? fileName,
    String? className,
    String? delimiter,
    int? startIndex,
    bool? dependOnContext,
    bool? useSingleQuotes,
    bool? replaceNoBreakSpaces,
    bool? exposeGetString,
    bool? exposeLocaStrings,
    bool? exposeLocaleMaps,
  }) async {
    // check that the file exists
    final file = File(inputFilePath);
    if (!file.existsSync()) {
      FlappyLogger.logError('File $inputFilePath does not exist!');
    }

    // check that the file has an extension - this is needed to determine if the file is supported
    if (!file.path.contains('.')) {
      FlappyLogger.logError('File $inputFilePath has no specified extension!');
    }

    // check that the file extension is correct
    if (!file.hasValidExtension) {
      FlappyLogger.logError(
        'File $inputFilePath has extension ${file.extensionType} which is not supported!',
      );
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
    codeGenerator.setSupportedLanguages(supportedLanguages);
    FlappyLogger.logProgress('Locales $supportedLanguages determined.');

    final localizationsTable = parser.localizationsTable;
    FlappyLogger.logProgress('Parsing ${localizationsTable.length} key(s)...');

    for (final row in localizationsTable) {
      final key = row.key;

      if (constants.reservedWords.contains(row.key)) {
        FlappyLogger.logError(
            'Key $key in row $row is a reserved keyword in Dart and is thus invalid.');
      }

      if (constants.types.contains(key)) {
        FlappyLogger.logError(
            'Key $key in row $row is a type in Dart and is thus invalid.');
      }

      if (!key.isValidVariableName) {
        FlappyLogger.logError(
            'Key $key in row $row is invalid. Expected key in the form lowerCamelCase.');
      }

      final words = row.words;
      if (words.length > supportedLanguages.length) {
        FlappyLogger.logError(
            'The row $row does not seem to be well formatted. Found ${words.length} values for ${supportedLanguages.length} locales.');
      }

      final defaultWord = row.defaultWord;
      if (defaultWord.isEmpty) {
        FlappyLogger.logError(
            'Key $key in row $row has no translation for default language.');
      }

      codeGenerator.addField(key, defaultWord, words);
    }

    codeGenerator.finalize();

    // format the contents according to dart defaults
    final formattedString = codeGenerator.formattedString;

    // write output file
    final path = outputDir.isEmpty ? 'i18n.dart' : '$outputDir/$fileName.dart';
    FileWriter().write(contents: formattedString, path: path);

    FlappyLogger.logProgress('Localizations sucessfully generated!');
  }
}
