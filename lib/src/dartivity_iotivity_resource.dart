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
  List<String> _resourceTypes;

  List<String> get resourceTypes => _resourceTypes;

  /// Interface types
  List<String> _interfaceTypes;

  List<String> get interfaceTypes => _interfaceTypes;

  /// Observable
  bool _observable = false;

  bool get observable => _observable;

  /// Construction
  DartivityIotivityResource(int ptr, String id, String uri, String host,
                            List<String> resTypes, List<String> intTypes, bool observable) {
    if (ptr ==
    null) throw new DartivityException(DartivityException.NULL_NATIVE_PTR);

    this._ptr = ptr;
    this._identifier = id;
    this._uri = uri;
    this._host = host;
    this._observable = observable;
    this._resourceTypes = resTypes;
    this._interfaceTypes = intTypes;

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

  static const String MAP_IDENTIFIER = "Identifier";
  static const String MAP_URI = "Uri";
  static const String MAP_HOST = "Host";
  static const String MAP_OBSERVABLE = "Observeable";
  static const String MAP_RESOURCE_TYPES = "ResTypes";
  static const String MAP_INTERFACE_TYPES = "IntTypes";

  /// toMap
  Map<String, Dynamic> toMap() {
    Map<String, Dynamic> returnMap = new Map<String, Dynamic>();

    returnMap[MAP_IDENTIFIER] = this._identifier;
    returnMap[MAP_URI] = this._uri;
    returnMap[MAP_HOST] = this._host;
    returnMap[MAP_OBSERVABLE] = this._observable;
    returnMap[MAP_RESOURCE_TYPES] = this._resourceTypes;
    returnMap[MAP_INTERFACE_TYPES] = this._interfaceTypes;

    return returnMap;
  }

  /// toJson
  String toJson() {

    jsonobject.JsonObject temp = new jsonobject.JsonObject.fromMap(toMap());
    return temp.toString();

  }
}
