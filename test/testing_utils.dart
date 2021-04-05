import 'package:flappy_translator/src/utils/flappy_logger.dart';
import 'package:test/test.dart';

final Matcher throwsAssertionError = throwsA(isAssertionError);
final TypeMatcher<AssertionError> isAssertionError = isA<AssertionError>();

void setTestingEnvironment() => isTestingEnvironment = true;
