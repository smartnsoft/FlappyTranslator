import 'dart:io';

import 'package:flappy_translator/flappy_translator.dart';
import 'package:yaml/yaml.dart';

void main() {
  String? inputFilePath;

  // try to load settings from the project's pubspec.yaml
  final settings = _loadSettings();
  if (settings.isNotEmpty) {
    if (settings.containsKey(_YamlArguments.inputFilePath)) {
      inputFilePath = settings[_YamlArguments.inputFilePath];
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
    outputDir: settings[_YamlArguments.outputDir],
    fileName: settings[_YamlArguments.fileName],
    className: settings[_YamlArguments.className],
    delimiter: settings[_YamlArguments.delimiter],
    startIndex: settings[_YamlArguments.startIndex],
    dependOnContext: settings[_YamlArguments.dependOnContext],
    useSingleQuotes: settings[_YamlArguments.useSingleQuotes],
    replaceNoBreakSpaces: settings[_YamlArguments.replaceNoBreakSpaces],
    exposeGetString: settings[_YamlArguments.exposeGetString],
    exposeLocaStrings: settings[_YamlArguments.exposeLocaStrings],
    exposeLocaleMaps: settings[_YamlArguments.exposeLocaleMaps],
  );
}

/// The path to the pubspec file path
const _pubspecFilePath = 'pubspec.yaml';

/// The section id for flappy-translator in the yaml file
const _yamlSectionId = 'flappy_translator';

/// A class of arguments which the user can specify in pubspec.yaml
class _YamlArguments {
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

/// Returns configuration settings for flappy_translator from pubspec.yaml
Map<String?, dynamic> _loadSettings() {
  final file = File(_pubspecFilePath);
  final yamlString = file.readAsStringSync();
  final Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);

  // determine <String?, dynamic> map from <dynamic, dynamic> yaml
  final settings = <String?, dynamic>{};
  if (yamlMap.containsKey(_yamlSectionId)) {
    for (final kvp in yamlMap[_yamlSectionId].entries) {
      settings[kvp.key] = kvp.value;
    }
  }

  return settings;
}
