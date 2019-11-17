/// The default output directory
const defaultOutputDirectory = 'lib';

/// The default class name
const defaultClassName = 'I18n';

/// The default (output) filename
const defaultFileName = 'i18n';

/// The default field delimiter for CSV file
const defaultDelimiter = ',';

/// The default index where the loca should be parsed from.
/// Assumes the csv is in the format: keys | fr | en | de etc.
const defaultStartIndex = 1;

/// The default value for whether the generated code should depend on context
const defaultDependOnContext = true;

/// The default value for whether the generated code should use single or double quotes for strings.
/// Single is default for Dart but user may wish to use double to avoid needing to escape \' etc.
const defaultUseSingleQuotes = false;
