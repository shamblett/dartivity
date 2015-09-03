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

  /// Iotivity resource identifier
  String resourceId;

  /// Iotivity resource details
  Map<String, String> resourceDetails;

  DartivityMessage();

  DartivityMessage.whoHas(String source, String resourceId) {
    if ((source == null) || (resourceId == null)) {
      throw new DartivityException(DartivityException.INVALID_WHOHAS_MESSAGE);
    }
    this.type = Type.whoHas;
    this.source = source;
    this.resourceId = resourceId;
  }

  DartivityMessage.iHave(String source, String destination, String resourceId, Map resourceDetails) {
    if ((source == null) || (resourceDetails == null) || (destination == null) || (resourceId == null)) {
      throw new DartivityException(DartivityException.INVALID_IHAVE_MESSAGE);
    }
    this.type = Type.iHave;
    this.source = source;
    this.destination = destination;
    this.resourceId = resourceId;
    this.resourceDetails = resourceDetails;
  }

  DartivityMessage.resourceInfo(String source, String destination, String resourceId, Map resourceDetails) {
    if ((source == null) || (resourceDetails == null) || (destination == null) || (resourceId == null)) {
      throw new DartivityException(DartivityException.INVALID_RESOURCE_INFO_MESSAGE);
    }
    this.type = Type.resourceInfo;
    this.source = source;
    this.destination = destination;
    this.resourceId = resourceId;
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
      source = jsonobj.containsKey('source') ? jsonobj.source : null;
      destination =
      jsonobj.containsKey('destination') ? jsonobj.destination : null;
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
    resourceDetails != null ? output.resourceDetails = resourceDetails : null;
    return output.toString();
  }

  /// toString
  String toString() {
    return "Type : ${type}, Source : ${source}, Resource : ${resourceDetails.toString()}";
  }
}
