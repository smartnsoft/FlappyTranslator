import 'package:flappy_translator/flappy_logger.dart';
import 'package:flappy_translator/flappy_translator.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    FlappyLogger.logError("Missing arguments (arguments are CSV file's name (mandatory) and target's file path)");
    return;
  }

  final flappyTranslator = FlappyTranslator();
  flappyTranslator.generate(arguments.first, targetPath: arguments.length == 2 ? arguments[1] : null);
}
