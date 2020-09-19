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
