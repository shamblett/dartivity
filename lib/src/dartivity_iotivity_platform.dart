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
  Future<DartivityIotivityResource> findResource(
      String host, String resourceName,
      [int connectivity = DartivityIotivityCfg.OCConnectivityType_Ct_Default]) {
    var completer = new Completer();
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
          // A resource, passed back are ptr, unique id, uri, host, resource types
          // interface types and observable
          DartivityIotivityResource resource = new DartivityIotivityResource(
              result[0],
              result[1],
              result[2],
              result[3],
              result[4],
              result[5],
              result[6]);
          completer.complete(resource);
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
