# flappy_translator

A Flutter internationalized strings generator which automatically imports localization strings from a CSV file. 

This is especially useful as any team member can work on a CSV file, with the translations imported into the project with the use of a simple terminal command. This contrasts starkly to the default i18n approach in which dart files need to be manually for new keys and languages.

## Getting Started

In order to use the *flappy_translator* package, please provide your translations in a CSV file - separators `,` and `;` have been tested to work.

### Create a CSV file

Consider that we have a table of localizations for the following languages:

| keys | fr | en | es | de_CH |
| ---- | -- | -- | -- | ----- |
| appTitle | Ma super application | My awesome application | Mi gran application | Meine tolle App |
| subtitle | Un sous titre | A subtitle | Un subtitulò | Ein Untertitel |
| description | Un texte avec une variable : %1$s | Text with a variable: %1$s | Un texto con una variable : %1$s | Text mit einer Variable: %1$s |
| littleTest | "Voici, pour l'exemple, ""un test"" avec la variable %age$d" | "Here is, for the example, ""a test"" with the variable %age$d" | "Aqui esta, por ejemplo, ""una prueba"" con la variable %age$d" | "Hier ist, zum Beispiel, ""ein Test"" mit der Variable %age$d" |

This spreadsheet would be exported as the following CSV file:

```
keys,fr,en,es,de_CH
appTitle,Ma super application,My awesome application,Mi gran application,Meine tolle App
subtitle,Un sous titre,A subtitle,Un subtitulò,Ein Untertitle
description,Un texte avec une variable : %1$s,Text with a variable: %1$s,Un texto con una variable : %1$s,Text mit einer Variable: %1$s
littleTest,"Voici, pour l'exemple, ""un test"" avec la variable %age$d","Here is, for the example, ""a test"" with the variable %age$d","Aqui esta, por ejemplo, ""una prueba"" con la variable %age$d","Hier ist, zum Beispiel, ""ein Test"" mit der Variable %age$d"
```

### Add dependency

```
dependencies:
  flutter_localizations:
    sdk: flutter
    
dev_dependencies: 
  flappy_translator: 
```

### Define Settings

Settings for *flappy_translator* can be optionally set in your project's *pubspec.yaml* file:

```yaml
flappy_translator:
  input_file_path: "test.csv"
  output_dir: "lib"
  file_name: "i18n"
  class_name: "I18n"
  delimiter: ","
  start_index: 1
  depend_on_context: true
  use_single_quotes: false
  replace_no_break_spaces: false
  expose_get_string: false
  exposeLocaStrings: false
```

| Setting                 | Default | Description                                                                      |
| ----------------------- | ------- | -------------------------------------------------------------------------------- |
| input_file_path         | N/A     | A path to the input CSV file.                                                    |
| output_dir              | lib     | A directory to generate the output file.                                         |
| file_name               | i18n    | A filename for the generated file.                                               |
| class_name              | I18n    | A class name for the generated file.                                             |
| delimiter               | ,       | A delimited to separate columns in the input CSV file.                           |
| start_index             | 1       | The column index where translations begin (i.e. column index of main language.)  |
| depend_on_context       | true    | Whether the generated localizations should depend on *BuildContext*              |
| use_single_quotes       | false   | Whether the generated file should use single or double quotes for strings.       |
| replace_no_break_spaces | false   | Whether no break spaces (\u00A0) should be replaced with normal spaces (\u0020). |
| expose_get_string       | false   | The default value for whether a getString method should be exposed.              |
| expose_loca_strings     | false   | The default value for whether locaStrings getter should be exposed.              |

### Run package

Make sure that your current working directory is the project root.

A file path to the CSV file must be supplied, either as a setting in *pubspec.yaml* or as a command line argument (CLA), while the output directory can also be optionally supplied as a CLA.

```
flutter pub get
flutter pub run flappy_translator <test.csv> <output dir>
```

### Use the i18n generated file

The package used your CV file in order to generate a file named *file_name* in *output_dir* you provided. The following example uses the default *class_name* I18n with a dependency on *BuildContext*:

1. Add the I18nDelegate to your delegates

```
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
```

2. Use your generated I18n class ! :)

```
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(I18n.of(context).appTitle),
              Text(I18n.of(context).description(var1: 2)),
              Text(I18n.of(context).littleTest(age: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Update iOS Info.plist

For iOS, *ios/Runner/Info.plist* needs to be updated with an array of the languages that the app supports:

```plist
<key>CFBundleLocalizations</key>
<array>
  <string>fr</string>
  <string>en</string>
  <string>es</string>
  <string>de</string>
</array>
```

For more information, see [Internationalizing Flutter apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#appendix-updating-the-ios-app-bundle).

## Rules and functionalities

### Default language

The `first` language's column of your CSV file will be considered as the `default` one.
That means : 

* If other languages does not have translation for specific words, it will take the corresponding one in the default language.

* The first column must be totally filled ! It will not work otherwise.

### Handling different languages for one country

You have the possibility, since version 1.4 to write something like `de_CH`.
It will take the Swiss's German language.

### Add variables in Strings

We added the possibility to handle variables in the Strings.
This means respecting some rules : 

1. In order to be able to recognize them, you must write them this way :

* %myVariable$d (`d` stands for an int type)
* %myVariable$s (`s` stands for a String type)

2. if your variable's name start with a number, the generated name will be `varmyVariable`
Otherwise, the generated variable name would be the name you provided.

* `%1$d` becomes `var1`
* `%age$d` becomes `age`

3. Variables are optional in the generated dart code

Let's take the example of the `description` String in the CSV we used.

The generated function signature will be :

```
String description({String var1,})
```

If the variables are not provided, the String will be given without replacing the variables placeholders.
