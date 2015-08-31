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
  static const FAILED_TO_INITIALISE_MESSAGER =
  'The messaging client has failed to initialise';
  static const FAILED_TO_INITIALISE_IOTCLIENT =
  'The iotivity client has failed to initialise';

  String _message = 'No Message Supplied';

  /**
   * Dartivity exception
   */
  DartivityException([this._message]);

  String toString() => HEADER + "${_message}";
}
