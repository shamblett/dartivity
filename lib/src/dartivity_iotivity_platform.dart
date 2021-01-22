/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityPlatform {
  DartivityIotivityPlatform();

  /// Function identifiers
  static const int _cfg = 1;

  /// Configure
  Future configure(DartivityIotivityCfg cfg) {
    final completer = new Completer();
    completer.complete();
    return completer.future;
  }

  /// findResource
  Future<List<DartivityClientIotivityResource>> findResource(
      String? host, String? resourceName,
      [int connectivity =
          DartivityIotivityCfg.ocConnectivityTypeCtDefault]) async {
    final completer = new Completer();
    completer.complete(null);
    return completer.future as FutureOr<List<DartivityClientIotivityResource>>;
  }
}
