/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityException implements Exception {
  // Exception message strings
  static const HEADER = 'DartivityException: ';
  static const NO_CREDPATH_SPECIFIED =
  'You must specify a credentials path for messaging';
  static const NO_PROJECTNAME_SPECIFIED =
  'You must specify a project name for messaging';
  static const FAILED_TO_INITIALISE_MESSAGER =
  'The messaging client has failed to initialise';
  static const FAILED_TO_INITIALISE_IOTCLIENT =
  'The iotivity client has failed to initialise';
  static const INVALID_WHOHAS_MESSAGE =
  'A whoHas message must have a source and resource id';
  static const INVALID_IHAVE_MESSAGE =
  'A iHave message must have a source, destination, resource id and resource details';
  static const INVALID_RESOURCE_DETAILS_MESSAGE =
  'A resource details message must have a source, destination, resource id and resource details';
  static const SUBSCRIPTION_FAILED =
  'Failed to create the messging subscription';
  static const IOT_PLATFORM_CFG_FAILED =
  'Failed to configure the Iotivity platform';
  static const NO_IOT_CFG_SPECIFIED =
  'You must specify a configuration object for iotivity';
  static const IOT_FIND_RESOURCE_FAILED = 'Could not invoke find resource';
  static const NULL_NATIVE_PTR =
  'You must supply a native pointer for this class';
  String _message = 'No Message Supplied';

  /**
   * Dartivity exception
   */
  DartivityException([this._message]);

  String toString() => HEADER + "${_message}";
}
