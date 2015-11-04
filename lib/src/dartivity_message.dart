/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityMessage {
  /// Type
  Type _type = Type.unknown;

  Type get type => _type;

  /// Dartivity source
  String _source = "";

  String get source => _source;

  /// Dartivity Destination
  String _destination = "";

  String get destination => _destination;

  // Source/destination constants
  static const ADDRESS_GLOBAL = "global";
  static const ADDRESS_WEB_SERVER = "web-server";

  /// Resource name, also known as the resource Uri
  String _resourceName = "";

  String get resourceName => _resourceName;

  /// Resource host
  String _host = "";

  String get host => _host;

  /// Provider , eg Iotivity
  static const String PROVIDER_UNKNOWN = "Unknown";
  static const String PROVIDER_IOTIVITY = "Iotivity";
  String _provider = PROVIDER_UNKNOWN;

  String get provider => _provider;

  /// Resource details
  Map<String, dynamic> _resourceDetails = {};

  Map<String, dynamic> get resourceDetails => _resourceDetails;

  DartivityMessage.whoHas(String source, String resourceName,
      [String host = ""]) {
    if ((source == null) || (resourceName == null) || (host == null)) {
      throw new DartivityException(DartivityException.INVALID_WHOHAS_MESSAGE);
    }
    _type = Type.whoHas;
    _source = source;
    _destination = ADDRESS_GLOBAL;
    _resourceName = resourceName;
    _host = host;
  }

  DartivityMessage.iHave(String source, String destination, String resourceName,
      Map<String, dynamic> resourceDetails, String host, String provider) {
    if ((source == null) ||
        (resourceDetails == null) ||
        (destination == null) ||
        (resourceName == null) ||
        (host == null) ||
        (provider == null)) {
      throw new DartivityException(DartivityException.INVALID_IHAVE_MESSAGE);
    }
    _type = Type.iHave;
    _source = source;
    _destination = destination;
    _resourceName = resourceName;
    _resourceDetails = resourceDetails;
    _host = host;
    _provider = provider;
  }

  /// fromJson
  DartivityMessage.fromJSON(String input) {
    if (input == null) {
      _type = Type.unknown;
    } else {
      jsonobject.JsonObject jsonobj =
      new jsonobject.JsonObject.fromJsonString(input);
      List<Type> types = Type.values;
      _type = jsonobj.containsKey('type') ? types[jsonobj.type] : Type.unknown;
      _host = jsonobj.containsKey('host') ? jsonobj.host : "";
      _provider =
      jsonobj.containsKey('provider') ? jsonobj.provider : PROVIDER_UNKNOWN;
      _source = jsonobj.containsKey('source') ? jsonobj.source : "";
      _destination =
      jsonobj.containsKey('destination') ? jsonobj.destination : "";
      _resourceName =
      jsonobj.containsKey('resourceName') ? jsonobj.resourceName : "";
      _resourceDetails =
      jsonobj.containsKey('resourceDetails') ? jsonobj.resourceDetails : {};
    }
  }

  /// fromJsonObject
  DartivityMessage.fromJSONObject(jsonobject.JsonObject input) {
    if (input == null) {
      _type = Type.unknown;
    } else {
      List<Type> types = Type.values;
      _type = input.containsKey('type') ? types[input.type] : Type.unknown;
      _source = input.containsKey('source') ? input.source : "";
      _destination = input.containsKey('destination') ? input.destination : "";
      _resourceName =
      input.containsKey('resourceName') ? input.resourceName : "";
      _resourceDetails =
      input.containsKey('resourceDetails') ? input.resourceDetails : "{}";
      _host = input.containsKey('host') ? input.host : "";
      _provider =
      input.containsKey('provider') ? input.provider : PROVIDER_UNKNOWN;
    }
  }

  /// toJSON
  String toJSON() {
    jsonobject.JsonObject output = new jsonobject.JsonObject();
    output.type = type.index;
    output.source = _source;
    output.destination = _destination;
    output.resourceName = _resourceName;
    output.resourceDetails = _resourceDetails;
    output.host = _host;
    output.provider = _provider;
    return output.toString();
  }

  /// toString
  String toString() {
    return "Type : ${type}, Provider : ${provider}, Host : ${host}, Source : ${source}, Destination : ${destination}, Resource Name : ${resourceName}, Resource Details : ${resourceDetails
        .toString()}";
  }

  /// equals ovverride
  bool operator ==(DartivityMessage other) {
    bool state = false;
    this.resourceName == other.resourceName ? state = true : null;
    return state;
  }
}
