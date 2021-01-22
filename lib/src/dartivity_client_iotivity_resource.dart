/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

/// This class is a client specific wrapper class for the database
/// supplied DartivityIotivityResource class. The ptr value is specific
/// to the client only and is not propagated into the rest of the Dartivity
/// suite.
part of dartivity;

class DartivityClientIotivityResource {
  DartivityClientIotivityResource(
      int ptr, db.DartivityIotivityResource resource) {
    _ptr = ptr;
    _resource = resource;
    _id = resource.id;
  }

  /// Class pointer for the C++ extension
  int? _ptr;

  int? get ptr => _ptr;

  /// Id, this is needed by the cache
  String? _id;

  String? get id => _id;

  /// The Dartivity Iotivity resource
  db.DartivityIotivityResource? _resource;

  db.DartivityIotivityResource? get resource => _resource;
}
