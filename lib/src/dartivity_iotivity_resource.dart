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
  static const int _TYPES = 2;

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
  String _host;

  String get host => _host;

  /// Uri
  String _uri;
  String get uri => _uri;

  /// Server identifier
  ///
  /// a string representation of the resource's server ID.
  /// This is unique per- server independent on how it was discovered.
  String _sid;

  String get sid => _sid;

  /// Resource types
  Future<List<String>> resourceTypes() {

    var completer = new Completer();
    var replyPort = new RawReceivePort();
    var args = new List(3);
    args[0] = _TYPES;
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

  /// Construction
  DartivityIotivityResource(int ptr, String id, String uri, String host) {
    if (ptr ==
    null) throw new DartivityException(DartivityException.NULL_NATIVE_PTR);

    this._ptr = ptr;
    this._identifier = id;
    this._uri = uri;
    this._host = host;

    // Create the sid from the id
    var tmp = _identifier.split("/");
    this._sid = tmp[0];

  }

  /// toString
  String toString() {

    return _identifier;
  }

  /// Equality
  bool operator ==(String other) {
    return (other.identifier == _identifier);
  }
}
