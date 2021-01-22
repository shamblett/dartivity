/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityException implements Exception {
  // Exception message strings
  static const String header = 'DartivityException: ';
  static const String noCredpathSpecified =
      'You must specify a credentials path for messaging';
  static const String noProjectnameSpecified =
      'You must specify a project name for messaging';
  static const String failedToInitialiseMessager =
      'The messaging client has failed to initialise';
  static const String failedToInitialiseIotclient =
      'The iotivity client has failed to initialise';
  static const String invalidWhohasMessage =
      'A whoHas message must have a source and resource id';
  static const String invalidIhaveMessage =
      'A iHave message must have a source, destination, resource id and resource details';
  static const String invalidResourceDetailsMessage =
      'A resource details message must have a source, destination, resource id and resource details';
  static const String subscriptionFailed =
      'Failed to create the messging subscription';
  static const String iotPlatformCfgFailed =
      'Failed to configure the Iotivity platform';
  static const String noIotCfgSpecified =
      'You must specify a configuration object for iotivity';
  static const String nullNativePtr =
      'You must supply a native pointer for this class';
  static const String iotResourceCallFailed = 'Failed to get resource data';
  final String? _message;

  /// Dartivity exception
  DartivityException([this._message]);

  @override
  String toString() => header + '${_message}';
}
