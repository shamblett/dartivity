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
  /// Class pointer for the C++ extension
  int _ptr;

  int get ptr => _ptr;

  /// The Dartivity Iotivty resource
  db.DartivityIotivityResource _resource;

  db.DartivityIotivityResource get resource => _resource;

  DartivityClientIotivityResource(int ptr,
      db.DartivityIotivityResource resource) {
    _ptr = ptr;
    _resource = resource;
  }
}
