/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivity {
  /// Ready, as in to use
  bool _ready = false;

  bool get ready => _ready;

  /// Client id
  String _clientId;

  /// Platform
  DartivityIotivityPlatform _platform;

  /// Client resource cache
  db.DartivityCache _cache;

  /// Iotivity specific constants
  static const String OC_RSRVD_WELL_KNOWN_URI = '/oic/res';

  DartivityIotivity(String clientId) {
    _clientId = clientId;
    _platform = new DartivityIotivityPlatform();
    _cache = new db.DartivityCache();
  }

  /// initialise
  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  Future<bool> initialise(DartivityIotivityCfg cfg) async {
    try {
      await _platform.configure(cfg);
      _ready = true;
    } catch (e) {
      _ready = false;
    }

    return _ready;
  }

  /// findResource
  Future<List<db.DartivityResource>> findResource(
      String host, String resourceName,
      [int connectivity =
          DartivityIotivityCfg.OCConnectivityType_Ct_Default]) async {
    Completer completer = new Completer();
    // Check the cache first
    List<db.DartivityResource> ret = new List<db.DartivityResource>();
    if (resourceName == OC_RSRVD_WELL_KNOWN_URI) {
      List<DartivityClientIotivityResource> resList = _cache
          .all()
          .values
          .toList();
      if (resList.length != 0) {
        resList.forEach((res) {
          ret.add(
              new db.DartivityResource.fromIotivity(res.resource, _clientId));
        });
        completer.complete(ret);
      }
    } else {
      db.DartivityResource res = _cache.get(resourceName);
      if (res != null) {
        ret.add(new db.DartivityResource.fromIotivity(res.resource, _clientId));
        completer.complete(ret);
      }
    }

    // If nothing in the cache try and find the resource
    if (!completer.isCompleted) {
      List<DartivityClientIotivityResource> res =
      await _platform.findResource(host, resourceName, connectivity);
      if (res != null) {
        List<db.DartivityResource> resList = new List<db.DartivityResource>();
        res.forEach((resource) {
          db.DartivityResource tmp = new db.DartivityResource.fromIotivity(
              resource.resource, _clientId);
          resList.add(tmp);
          _cache.put(tmp.id, resource);
        });
        completer.complete(resList);
      } else {
        completer.complete(null);
      }
    }
    return completer.future;
  }

  /// close
  void close() {}
}
