/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityResource {
  /// Native pointer
  int _ptr;

  /// Function identifiers
  static const int _HOST = 1;
  static const int _URI = 2;

  /// Send port
  static SendPort _port;

  SendPort _newServicePort() native "Resource_ServicePort";

  SendPort get _servicePort => _port == null ? _newServicePort() : _port;

  /// Resource identifier
  ///
  /// This will be guaranteed unique for every resource-per-server
  /// independent of how this was discovered.
  String _identifier;

  String get identifier => _identifier;

  /// Host
  Future<String> host() {

    var completer = new Completer();
    var replyPort = new RawReceivePort();
    var args = new List(3);
    args[0] = _HOST;
    args[1] = replyPort.sendPort;
    args[2] = _ptr;

    _servicePort.send(args);
    replyPort.handler = (result) {
      replyPort.close();
      if (result != null) {
        completer.complete(result);
      } else {
        completer.completeError(
            new DartivityException(DartivityException.IOT_RESOURCE_CALL_FAILED));
      }
    };

    return completer.future;
  }

  /// Uri
  String _uri;

  String get uri => _uri;

  /*Future<String> uri() {

    var completer = new Completer();
    var replyPort = new RawReceivePort();
    var args = new List(3);
    args[0] = _URI;
    args[1] = replyPort.sendPort;
    args[2] = _ptr;

    _servicePort.send(args);
    replyPort.handler = (result) {
      replyPort.close();
      if (result != null) {
        completer.complete(result);
      } else {
        completer.completeError(
            new DartivityException(DartivityException.IOT_RESOURCE_CALL_FAILED));
      }
    };

    return completer.future;

  }*/

  /// Server identifier
  ///
  /// a string representation of the resource's server ID.
  /// This is unique per- server independent on how it was discovered.
  String _sid;

  String get sid => _sid;

  DartivityIotivityResource(int ptr, String id, String uri) {
    if (ptr ==
    null) throw new DartivityException(DartivityException.NULL_NATIVE_PTR);

    this._ptr = ptr;
    this._identifier = id;
    this._uri = uri;

    // Create the sid from the id
    var tmp = _identifier.split("/");
    this._sid = tmp[0];

  }

  /// toString
  String toString() {

    return _identifier;
  }
}
