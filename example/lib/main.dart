import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: I18nDelegate.supportedLocals,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(I18n.of(context).appTitle),
              Text(I18n.of(context).description(var1: '2')),
              Text(I18n.of(context).littleTest(age: 32)),
              Text(I18n.of(context).pluralTest(seconds: 24)),
              Text(I18n.of(context).pluralTest(seconds: 1)),
            ],
          ),
        ),
      ),
    );
  }
}
