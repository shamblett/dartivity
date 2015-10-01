/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityMessage {
  /// Type
  Type type;

  /// Dartivity source
  String source;

  /// Dartivity Destination
  String destination;
  static const DESTINATION_GLOBAL = "global";

  /// Iotivity resource name, also known as the resource Uri
  /// example is oic/res
  String resourceName;

  /// Iotivity resource host
  String host;

  /// Iotivity resource details
  Map<String, dynamic> resourceDetails;

  DartivityMessage();

  DartivityMessage.whoHas(String source, String resourceName) {
    if ((source == null) || (resourceName == null)) {
      throw new DartivityException(DartivityException.INVALID_WHOHAS_MESSAGE);
    }
    this.type = Type.whoHas;
    this.source = source;
    this.destination = DESTINATION_GLOBAL;
    this.resourceName = resourceName;
  }

  DartivityMessage.iHave(String source, String destination, String resourceName,
                         Map<String, dynamic> resourceDetails) {
    if ((source == null) ||
    (resourceDetails == null) ||
    (destination == null) ||
    (resourceName == null)) {
      throw new DartivityException(DartivityException.INVALID_IHAVE_MESSAGE);
    }
    this.type = Type.iHave;
    this.source = source;
    this.destination = destination;
    this.resourceName = resourceName;
    this.resourceDetails = resourceDetails;
  }


  DartivityMessage.fromJSON(String input) {
    if (input == null) {
      type = Type.unknown;
    } else {
      jsonobject.JsonObject jsonobj =
      new jsonobject.JsonObject.fromJsonString(input);
      List<Type> types = Type.values;
      type = jsonobj.containsKey('type') ? types[jsonobj.type] : Type.unknown;
      host = jsonobj.containsKey('host') ? jsonobj.host : "";
      source = jsonobj.containsKey('source') ? jsonobj.source : "";
      destination =
      jsonobj.containsKey('destination') ? jsonobj.destination : "";
      resourceName = jsonobj.containsKey('resourceName') ? jsonobj.resourceName : "";
      resourceDetails = jsonobj.containsKey('resourceDetails')
      ? jsonobj.resourceDetails
      : null;
    }
  }

  DartivityMessage.fromJSONObject(jsonobject.JsonObject input) {
    if (input == null) {
      type = Type.unknown;
    } else {
      List<Type> types = Type.values;
      type = input.containsKey('type') ? types[input.type] : Type.unknown;
      source = input.containsKey('source') ? input.source : null;
      destination = input.containsKey('destination') ? input.destination : null;
      resourceName = input.containsKey('resourceName') ? input.resourceName : null;
      resourceDetails =
      input.containsKey('resourceDetails') ? input.resourceDetails : null;
    }
  }

  /// toJSON
  String toJSON() {
    jsonobject.JsonObject output = new jsonobject.JsonObject();
    output.type = type.index;
    source != null ? output.source = source : null;
    destination != null ? output.destination = destination : null;
    resourceName != null ? output.resourceName = resourceName : null;
    resourceDetails != null ? output.resourceDetails = resourceDetails : null;
    return output.toString();
  }

  /// toString
  String toString() {
    return "Type : ${type}, Host : ${host}, Source : ${source}, Destination : ${destination}, Resource Name : ${resourceName}, Resource : ${resourceDetails.toString()}";
  }
}
