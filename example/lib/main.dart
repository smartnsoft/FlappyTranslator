import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
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
              Text(
                I18n.appTitle(context),
              ),
              Text(
                I18n.description(context, "toto", "tata", "titi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
