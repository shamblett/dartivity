/*
 * Package  = dartivity
 * Author  = S. Hamblett <steve.hamblett@linux.com>
 * Date    = 28/09/2015
 * Copyright  =  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityCfg {
  DartivityIotivityCfg(
      {int qos = qualityOfServiceNaQos,
      clientConnectivity = ocConnectivityTypeCtDefault,
      String ipAddress = '0.0.0.0',
      int port = 0}) {
    qualityOfService = qos;
    this.clientConnectivity = clientConnectivity;
    ip = ipAddress;
    this.port = port;
  }

  /// Service type, always ServiceType_InProc
  final int _serviceType = serviceTypeInProc;

  int get serviceType => _serviceType;

  static const int serviceTypeInProc = 0;
  static const int serviceTypeOutOfProc = 1;

  /// Host Mode of Operation, always ModeType_Client
  final int _mode = modeTypeClient;

  int get mode => _mode;

  static const int modeTypeServer = 0;
  static const int modeTypeClient = 1;
  static const int modeTypeBoth = 2;

  /// Quality of Service attempts to abstract the guarantees provided by the underlying transport
  /// protocol. The precise definitions of each quality of service level depend on the
  /// implementation. In descriptions below are for the current implementation and may changed
  /// over time.
  int qualityOfService = qualityOfServiceNaQos;

  // Best effort
  static const int qualityOfServiceLowQos = 0;

  // Best effort
  static const int qualityOfServiceMidQos = 1;

  // Ack confirmation
  static const int qualityOfServiceHighQos = 2;

  // Let the stack decide
  static const int qualityOfServiceNaQos = 3;

  /// Connectivity type
  int clientConnectivity = ocConnectivityTypeCtDefault;
  static const int ocConnectivityTypeCtDefault = 0;
  static const int ocConnectivityTypeCtAdapterIP = 1 << 16;
  static const int ocConnectivityTypeCtAdapterGattBtle = 1 << 17;
  static const int ocConnectivityTypeCtAdapterRfcommBtedr = 1 << 18;
  static const int ocConnectivityTypeCtAdapterRemoteAccess = 1 << 19;
  static const int ocConnectivityTypeCtFlagSecure = 1 << 4;
  static const int ocConnectivityTypeCtIPUseV6 = 1 << 5;
  static const int ocConnectivityTypeCtIPUseV4 = 1 << 6;
  static const int ocConnectivityTypeCtScopeInterface = 0x1;
  static const int ocConnectivityTypeCtScopeLink = 0x2;
  static const int ocConnectivityTypeCtScopeRealm = 0x3;
  static const int ocConnectivityTypeCtScopeAdmin = 0x4;
  static const int ocConnectivityTypeCtSite = 0x5;
  static const int ocConnectivityTypeCtScopeOrg = 0x8;
  static const int ocConnectivityTypeCtScopeGlobal = 0xE;

  /// IP address
  String ip = '0.0.0.0';

  /// Port
  int port = 0;
}
