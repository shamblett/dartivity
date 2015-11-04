/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityResource {
  /// Unique identifier
  String _id;

  String get id => _id;

  /// Provider
  String _provider = DartivityMessage.PROVIDER_UNKNOWN;

  String get provider => _provider;

  /// The actual resource from the provider
  dynamic _resource;

  dynamic get resource => _resource;

  /// fromIotivity
  DartivityResource.fromIotivity(DartivityIotivityResource resource,
      String clientId) {
    _id = clientId + '-' + resource.identifier;
    _provider = resource.provider;
    _resource = resource;
  }

  /// toString
  String toString() {
    return "Id : ${id}, Provider : ${provider}";
  }

  /// equals ovverride
  bool operator ==(DartivityResource other) {
    bool state = false;
    this.id == other.id ? state = true : null;
    return state;
  }
}
