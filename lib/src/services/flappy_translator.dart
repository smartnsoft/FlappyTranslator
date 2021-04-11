import 'dart:io';

import '../configs/default_settings.dart';
import '../extensions/file_extensions.dart';
import '../utils/flappy_logger.dart';
import 'code_generation/code_generator.dart';
import 'file_writer/file_writer.dart';
import 'parsing/csv_parser.dart';
import 'parsing/excel_parser.dart';
import 'validation/validator.dart';

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
  }) {
    final file = File(inputFilePath);
    Validator.validateFile(file);

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
    Validator.validateSupportedLanguages(supportedLanguages);
    codeGenerator.setSupportedLanguages(supportedLanguages);
    FlappyLogger.logProgress('Locales $supportedLanguages determined.');

    final localizationsTable = parser.localizationsTable;
    FlappyLogger.logProgress('Parsing ${localizationsTable.length} key(s)...');

    for (final row in localizationsTable) {
      Validator.validateLocalizationTableRow(
        row,
        numberSupportedLanguages: supportedLanguages.length,
      );
      codeGenerator.addField(row.key, row.defaultWord, row.words);
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
