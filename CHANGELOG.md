## [1.0.0] - 21/08/2019

* Initial Release

## [1.0.1] - 21/08/2019

* Fix documentation
* Fix template's file path

## [1.0.2] - 21/08/2019

* Fix template by handling a String instead of file

## [1.0.3] - 21/08/2019

* Fix error on CSV not well formed
* Fix error when using Dart reserved keywords

## [1.0.4] - 18/10/2019

* Handle possibility to have multiple languages for one country

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

## [1.2.0] - 06/12/2019 

* Add setting to handle "no break" spaces by replacing them by normal spaces