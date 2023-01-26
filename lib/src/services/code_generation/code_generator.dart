import 'package:dart_style/dart_style.dart';

import '../../configs/constants.dart' as constants;
import '../../configs/default_settings.dart';
import '../../utils/flappy_logger.dart';
import '../../extensions/list_extensions.dart';
import 'template.dart';

/// A service which generates I18n class and delegate using string concatenation
class CodeGenerator {
  final bool dependOnContext;
  final String _quoteString;
  final bool replaceNoBreakSpaces;
  final _parametersRegex = RegExp(r'(\%[[0-9a-zA-Z]+]*\$(d|s))');
  final List<String> _commentLanguages = [];

  late String _template;
  late List<Map<String, String>> _maps;
  late String _fields;
  late List<String> _supportedLanguages;

  /// Returns a string formatted according to default dart rules
  String get formattedString => DartFormatter().format(_template);

  CodeGenerator({
    String className = DefaultSettings.className,
    this.dependOnContext = DefaultSettings.dependOnContext,
    bool useSingleQuotes = DefaultSettings.useSingleQuotes,
    this.replaceNoBreakSpaces = DefaultSettings.replaceNoBreakSpaces,
    bool exposeGetString = DefaultSettings.exposeGetString,
    bool exposeLocaStrings = DefaultSettings.exposeLocaStrings,
    bool exposeLocaleMaps = DefaultSettings.exposeLocaleMaps,
  }) : _quoteString = useSingleQuotes ? '\'' : '"' {
    // construct template
    _template = Template.beginning +
        (dependOnContext
            ? Template.middleDependContext
            : Template.middleDontDependContext) +
        (exposeGetString ? Template.getString(dependOnContext) : '') +
        (exposeLocaStrings ? Template.locaStrings(dependOnContext) : '') +
        (exposeLocaleMaps ? Template.localeMaps(dependOnContext) : '') +
        Template.ending;
    _template = _template.replaceAll(TemplateKeys.className, className);

    // initialize local variables
    _fields = '';
  }

  void enableCommentGeneration([List<String> commentLanguages = const []]) {
    if (commentLanguages.isEmpty) {
      _commentLanguages.addAll(_supportedLanguages);
    } else {
      // make sure to not use languages that are not supported
      _commentLanguages.addAll(_supportedLanguages
          .where((supportedLang) => commentLanguages.contains(supportedLang)));
    }
  }

  void setSupportedLanguages(List<String> supportedLanguages) {
    _supportedLanguages = supportedLanguages;

    var supportedLocals = 'static final Set<Locale> supportedLocals = {\n';
    for (var lang in supportedLanguages) {
      final parts = lang.split('_');
      supportedLocals += parts.length == 1
          ? '''Locale('${parts[0]}')'''
          : '''Locale('${parts[0]}', '${parts[1]}')''';
      supportedLocals += ',\n';
    }
    supportedLocals += '};';

    _template = _template.replaceAll(
      TemplateKeys.supportedLanguagesArea,
      '''
      $supportedLocals
      
      @override
      bool isSupported(Locale locale) => supportedLocals.contains(locale);
      ''',
    );

    _maps = List.generate(supportedLanguages.length, (index) => {});
  }

  void addField(String key, String defaultWord, List<String> words) {
    var result = _supportedLanguages
        .mapIndexedWhere((i, lang) => '/// * $lang: ${words[i]} \n',
            (_, lang) => _commentLanguages.contains(lang))
        .join('');
    final getTextString = '_getText($_quoteString$key$_quoteString)';
    final hasParameters = _parametersRegex.hasMatch(defaultWord);
    if (hasParameters) {
      var parameters = '';
      final matches = _parametersRegex.allMatches(defaultWord).toList();
      for (final match in matches) {
        final parameterType = match.group(2) == 'd' ? 'int' : 'String';
        parameters +=
            'required $parameterType ${_getParameterNameFromPlaceholder(match.group(0)!)}, ';
      }

      result +=
          (!dependOnContext ? 'static ' : '') + 'String $key({$parameters}) =>';
      result += getTextString;

      for (final match in matches) {
        final placeholderName = _formatString(match.group(1)!);
        var varName = _getParameterNameFromPlaceholder(match.group(0)!);
        result += '''
        .replaceAll($_quoteString$placeholderName$_quoteString, ${varName += match.group(2) == 'd' ? '.toString()' : ''})
        ''';
      }

      result += ';\n\n';
    } else {
      result += (!dependOnContext ? 'static ' : '') +
          'String get $key => $getTextString;\n\n';
    }

    _fields += result;

    _maps[0][key] = defaultWord;
    for (var wordIndex = 1;
        wordIndex < _supportedLanguages.length;
        wordIndex++) {
      _maps[wordIndex][key] =
          wordIndex < words.length && words[wordIndex].isNotEmpty
              ? words[wordIndex]
              : defaultWord;
    }
  }

  String _getParameterNameFromPlaceholder(String placeholder) {
    var givenName = placeholder.substring(1, placeholder.length - 2);
    if (int.tryParse(givenName[0]) != null) {
      FlappyLogger.logWarning(
          'Variable name $givenName begins with a number. Prepending var.');
      givenName = 'var$givenName';
    } else if (constants.reservedWords.contains(givenName)) {
      FlappyLogger.logWarning(
          'Variable name $givenName is a reserved word in dart. Prepending var.');
      givenName = 'var$givenName';
    } else if (constants.types.contains(givenName)) {
      FlappyLogger.logWarning(
          'Variable name $givenName is a type in dart. Prepending var.');
      givenName = 'var$givenName';
    }
    return givenName;
  }

  void finalize() {
    _template = _template.replaceAll(TemplateKeys.fieldsArea, _fields);

    _generateMapValues();
  }

  void _generateMapValues() {
    final allValuesMap = <String, Map<String, String>>{};
    final mapsNames = <String>[];
    var result = '';

    for (var mapIndex = 0; mapIndex < _maps.length; mapIndex++) {
      final lang = _supportedLanguages[mapIndex];
      final map = _maps[mapIndex];
      final mapName = '_${lang.replaceAll('_', '')}Values';
      mapsNames.add(mapName);

      result += '''
      static const $mapName = {
      ''';

      map.forEach((key, value) {
        var formattedString = _formatString(value);
        if (_quoteString == '\'') {
          formattedString = formattedString.replaceAll('\'', '\\\'');
          // incase the string already had \' then it will become \\\\\', replace this with \\\'
          formattedString = formattedString.replaceAll('\\\\\'', '\\\'');
        }
        if (replaceNoBreakSpaces) {
          formattedString = _replaceNoBreakSpaces(formattedString);
        }
        result += '''
        $_quoteString$key$_quoteString: $_quoteString$formattedString$_quoteString,
        ''';
      });

      result += '};\n\n';

      allValuesMap[lang] = map;
    }

    result += '''
    static const _allValues = {
    ''';

    _supportedLanguages.asMap().forEach((index, lang) {
      result += '''
        $_quoteString$lang$_quoteString: ${mapsNames[index]},
      ''';
    });

    result += '};';

    _template = _template.replaceAll(TemplateKeys.valuesArea, result);
  }

  String _formatString(String text) {
    text = text.replaceAll('"', '\\"');
    text = text.replaceAll('\$', '\\\$');

    return text;
  }

  String _replaceNoBreakSpaces(String text) {
    // sometimes there can be the strange '194 160' space, ie `no break space`. replace this with a normal space.
    text = text.replaceAll('\u00A0', ' ');
    text = text.replaceAll(' ', ' ');

    return text;
  }
}
