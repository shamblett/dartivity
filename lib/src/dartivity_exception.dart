/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of  dartivity;

class DartivityException implements Exception {

  String _message = 'No Message Supplied';

  /**
   * Dartivity exception
   */
  DartivityException([this._message]);

  String toString() => "DartivityException: message = ${_message}";

}