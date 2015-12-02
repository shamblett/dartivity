/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityPlatform {
  /// Function identifiers
  static const int _CFG = 1;
  static const int _FIND_RESOURCE = 2;

  /// Send port
  static SendPort _port;

  SendPort _newServicePort() native "Platform_ServicePort";

  SendPort get _servicePort => _port == null ? _newServicePort() : _port;

  DartivityIotivityPlatform();

  /// Configure
  Future configure(DartivityIotivityCfg cfg) {
    var completer = new Completer();
    var replyPort = new RawReceivePort();
    var args = new List(10);
    args[0] = _CFG;
    args[1] = replyPort.sendPort;
    args[2] = cfg.serviceType;
    args[3] = cfg.mode;
    args[4] = cfg.qualityOfService;
    args[5] = cfg.clientConnectivity;
    args[6] = cfg.ip;
    args[7] = cfg.port;

    _servicePort.send(args);
    replyPort.handler = (result) {
      replyPort.close();
      if (result != null) {
        completer.complete(result);
      } else {
        completer.completeError(
            new DartivityException(DartivityException.IOT_PLATFORM_CFG_FAILED));
      }
    };

    return completer.future;
  }

  /// findResource
  Future<List<db.DartivityIotivityResource>> findResource(
      String host, String resourceName,
      [int connectivity =
      DartivityIotivityCfg.OCConnectivityType_Ct_Default]) async {
    var completer = new Completer();

    // Check the arguments before calling the extension
    if ((host == null) ||
        (resourceName == null) ||
        (connectivity == null)) completer.complete(null);

    var replyPort = new RawReceivePort();
    var args = new List(5);
    args[0] = _FIND_RESOURCE;
    args[1] = replyPort.sendPort;
    args[2] = host;
    args[3] = resourceName;
    args[4] = connectivity;

    _servicePort.send(args);
    replyPort.handler = (result) {
      replyPort.close();
      if (result != null) {
        if (result is List) {
          List<DartivityClientIotivityResource> resList =
          new List<DartivityClientIotivityResource>();
          result.forEach((entry) {
            // A resource, passed back are ptr, unique id, uri, host, resource types
            // interface types and observable. Ptr is not stored in the IotivityResource
            // but in the DartivityClientIotivityResource class
            db.DartivityIotivityResource resource = new db
                .DartivityIotivityResource(
                entry[1],
                entry[2],
                entry[3],
                entry[4],
                entry[5],
                entry[6]);
            DartivityClientIotivityResource iotres = new DartivityClientIotivityResource(
                entry[0], resource);
            resList.add(iotres);
          });
          completer.complete(resList);
        } else {
          // Anything else means not found
          completer.complete(null);
        }
      } else {
        // Null resource passed by iotivity, treat as not found.
        completer.complete(null);
      }
    };
    return completer.future;
  }
}
