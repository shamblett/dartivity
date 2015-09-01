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

  DartivityMessage.fromJSON(String input) {
    if (input == null) {
      type = Type.unknown;
    } else {
      jsonobject.JsonObject jsonobj =
          new jsonobject.JsonObject.fromJsonString(input);
      type = jsonobj.type;
      source = jsonobj.source;
      destination = jsonobj.destination;
      resourceDetails = jsonobj.resourceDetails;
    }
  }

  /// toJSON
  String toJSON() {
    jsonobject.JsonObject output = new jsonobject.JsonObject();
    output.type = type;
    output.source = source;
    output.destination = destination;
    output.resourceDetails = resourceDetails;
    return output.toString();
  }
}
