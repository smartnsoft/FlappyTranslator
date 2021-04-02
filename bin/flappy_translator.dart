import 'dart:io';

import 'package:flappy_translator/flappy_translator.dart';
import 'package:yaml/yaml.dart';

/// The path to the pubspec file path
const pubspecFilePath = 'pubspec.yaml';

/// The section id for flappy-translator in the yaml file
const yamlSectionId = 'flappy_translator';

/// A class of arguments which the user can specify in pubspec.yaml
class YamlArguments {
  static const inputFilePath = 'input_file_path';
  static const outputDir = 'output_dir';
  static const className = 'class_name';
  static const fileName = 'file_name';
  static const delimiter = 'delimiter';
  static const startIndex = 'start_index';
  static const dependOnContext = 'depend_on_context';
  static const useSingleQuotes = 'use_single_quotes';
  static const replaceNoBreakSpaces = 'replace_no_break_spaces';
  static const exposeGetString = 'expose_get_string';
  static const exposeLocaStrings = 'expose_loca_strings';
  static const exposeLocaleMaps = 'expose_locale_maps';
}

void main() {
  String? inputFilePath;

  // try to load settings from the project's pubspec.yaml
  final settings = loadSettings();
  if (settings.isNotEmpty) {
    if (settings.containsKey(YamlArguments.inputFilePath)) {
      inputFilePath = settings[YamlArguments.inputFilePath];
    }
  }

  // display an error and quit if the input file hasn't been specified
  if ((inputFilePath == null)) {
    print('[ERROR] Input file path not defined. This can be set as a command line argument or in pubspec.yaml\n');
    return;
  }

  // parse csv to dart
  final flappyTranslator = FlappyTranslator();
  flappyTranslator.generate(
    inputFilePath,
    outputDir: settings[YamlArguments.outputDir],
    fileName: settings[YamlArguments.fileName],
    className: settings[YamlArguments.className],
    delimiter: settings[YamlArguments.delimiter],
    startIndex: settings[YamlArguments.startIndex],
    dependOnContext: settings[YamlArguments.dependOnContext],
    useSingleQuotes: settings[YamlArguments.useSingleQuotes],
    replaceNoBreakSpaces: settings[YamlArguments.replaceNoBreakSpaces],
    exposeGetString: settings[YamlArguments.exposeGetString],
    exposeLocaStrings: settings[YamlArguments.exposeLocaStrings],
    exposeLocaleMaps: settings[YamlArguments.exposeLocaleMaps],
  );
}

/// Returns configuration settings for flappy_translator from pubspec.yaml
Map<String?, dynamic> loadSettings() {
  final file = File(pubspecFilePath);
  final yamlString = file.readAsStringSync();
  final Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);

  // determine <String?, dynamic> map from <dynamic, dynamic> yaml
  final settings = <String?, dynamic>{};
  if (yamlMap.containsKey(yamlSectionId)) {
    for (final kvp in yamlMap[yamlSectionId].entries) {
      settings[kvp.key] = kvp.value;
    }
  }

  return settings;
}
