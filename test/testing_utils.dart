import 'package:test/test.dart';

final Matcher throwsAssertionError = throwsA(isAssertionError);
final TypeMatcher<AssertionError> isAssertionError = isA<AssertionError>();
