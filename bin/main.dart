import 'package:flappy_translator/flappy_logger.dart';
import 'package:flappy_translator/flappy_translator.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    FlappyLogger.logError("Missing arguments");
    return;
  }

  final flappyTranslator = FlappyTranslator();
  flappyTranslator.generate(arguments.first);
}
