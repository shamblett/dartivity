/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityPlatform {

  /// Function identifiers
  static const int CFG = 1;
  static const int FIND_RESOURCE = 2;

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
    args[0] = CFG;
    args[1] = replyPort.sendPort;
    args[2] = cfg.serviceType;
    args[3] = cfg.mode;
    args[4] = cfg.qualityOfService;
    args[5] = cfg.clientConnectivity;
    args[6] = cfg.serverConnectivity;
    args[7] = cfg.ip;
    args[8] = cfg.port;
    args[9] = cfg.dbFile;


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
  DartivityIotivityResource findResource(String host, String resourceName,
                                         [int connectivity = DartivityIotivityCfg.OCConnectivityType_Ct_Default]) {

    var completer = new Completer();
    var replyPort = new RawReceivePort();
    var args = new List(4);
    args[0] = host;
    args[1] = resourceName;
    args[2] = connectivity;
    args[3] = replyPort.sendPort;

    _servicePort.send(args);
    replyPort.handler = (result) {
      replyPort.close();
      if (result != null) {
        //TODO get the returned values and build a resource class
        completer.complete(result);
      } else {
        completer.completeError(
            new DartivityException(DartivityException.IOT_FIND_RESOURCE_FAILED));
      }
    };

    return completer.future;
  }
}
