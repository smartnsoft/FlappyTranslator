## [2.1.0] - 20/10/2024

* Set Dart 3 as minimum constraint
* Using csv parsing logic from arb_generator

## [2.0.0] - 31/03/2023

* First official 2.0.0 release as excel is now also officially released.
* Ignore non_constant_identifier_names lint in generated code.
* Fix typo in success message.

## [2.0.0-nullsafety.3] - 02/07/2022

* Adds ability to generate comments with localization details.
* When no value (or empty) is given for default language, then the key is used as localization value.

## [2.0.0-nullsafety.2] - 26/05/2021

* Fixes an issue where certain analyzer warnings would be triggered in the generated code when using lint package.
* Updates example.

## [2.0.0-nullsafety.1] - 10/04/2021

* Adds null safety support
* Breaking change: input file path can no longer be given as command line argument
* Logs an error when a locale is invalid
* Logs an warning when a locale is not supported by Flutter
* Improved test coverage

## [1.5.0] - 19/10/2020

* Adds support to generate localization resources from Excel files (XLSX)
* Removes dependency on Flutter and increases Dart SDK constraint to >= 2.7
* Fixes a bug where a variable named `text` would not be correctly processed
* Fixes a bug where variables named as dart keywords would crash code generation
* Updates the example to be compatible with newer versions of flutter

## [1.4.0] - 20/09/2020 

* The getter `locaStrings` (map of key-locastring for the current locale) can now be generated depending on the input setting `expose_loca_strings`
* The getter `localeMaps` (map of loca maps per locale) can now be generated depending on the input setting `expose_locale_maps`

## [1.3.0] - 05/09/2020 

* The method `getString(String key)` can now be generated depending on the input setting `expose_get_string`
* Variable names are now checked if they are valid (i.e. myVar is valid, both my-Var and MyVar aren't)
* To avoid generated code triggering warnings, certain rules are now ignored. This is a temporary solution until v2.0.0

## [1.2.2] - 27/01/2020 

* Fix issue on Locale written in camelCase

## [1.2.1] - 24/01/2020 

* Make sure that snake_case countries like `de_CH` are written in camelCase in generated file

## [1.2.0] - 06/12/2019 

* Add setting to handle "no break" spaces by replacing them by normal spaces

## [1.1.0] - 02/12/2019  
  
* Add lot of configurations in pubspec.yaml :  
	* Ability to define generated filename and classname
	* Ability to use other delimiter than ","
	* Ability to have other columns between keys and values (one for description for example)
	* No need for BuildContext
	* Ability to use double or simple quotes on generated file
* Additionally :
	* All generated parameters are now *@required*
	* Added *currentLocale* to generated file
	* Better Readme.md

## [1.0.4] - 18/10/2019

* Handle possibility to have multiple languages for one country

## [1.0.3] - 21/08/2019

* Fix error on CSV not well formed
* Fix error when using Dart reserved keywords

## [1.0.2] - 21/08/2019

* Fix template by handling a String instead of file

## [1.0.1] - 21/08/2019

* Fix documentation
* Fix template's file path

## [1.0.0] - 21/08/2019

* Initial Release
