abstract class FileParser {
  List<String> getSupportedLanguages(List<String> fileLines);
  List<String> getWordsOfLine(String line);
}
