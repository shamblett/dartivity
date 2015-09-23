/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityCfg {
  /// Service type, always ServiceType_InProc
  int _serviceType = ServiceType_InProc;

  int get serviceType => _serviceType;
  static const int ServiceType_InProc = 0;
  static const int ServiceType_OutOfProc = 1;

  /// Host Mode of Operation, always ModeType_Client
  int _mode = ModeType_Client;

  int get mode => _mode;
  static const int ModeType_Server = 0;
  static const int ModeType_Client = 1;
  static const int ModeType_Both = 2;

  /// Quality of Service attempts to abstract the guarantees provided by the underlying transport
  /// protocol. The precise definitions of each quality of service level depend on the
  /// implementation. In descriptions below are for the current implementation and may changed
  /// over time.
  int qualityOfService = QualityOfService_NaQos;

  // Best effort
  static const int QualityOfService_LowQos = 0;

  // Best effort
  static const int QualityOfService_MidQos = 1;

  // Ack confirmation
  static const int QualityOfService_HighQos = 2;

  // Let the stack decide
  static const int QualityOfService_NaQos = 3;

  /// Connectivity type
  int clientConnectivity = OCConnectivityType_Ct_Default;
  static const int OCConnectivityType_Ct_Default = 0;
  static const int OCConnectivityType_Ct_Adapter_IP = 1 << 16;
  static const int OCConnectivityType_Ct_Adapter_Gatt_Btle = 1 << 17;
  static const int OCConnectivityType_Ct_Adapter_Rfcomm_Btedr = 1 << 18;
  static const int OCConnectivityType_Ct_Adapter_Remote_Access = 1 << 19;
  static const int OCConnectivityType_Ct_Flag_Secure = 1 << 4;
  static const int OCConnectivityType_Ct_IP_Use_V6 = 1 << 5;
  static const int OCConnectivityType_Ct_IP_Use_V4 = 1 << 6;
  static const int OCConnectivityType_Ct_Scope_Interface = 0x1;
  static const int OCConnectivityType_Ct_Scope_Link = 0x2;
  static const int OCConnectivityType_Ct_Scope_Realm = 0x3;
  static const int OCConnectivityType_Ct_Scope_Admin = 0x4;
  static const int OCConnectivityType_Ct_Site = 0x5;
  static const int OCConnectivityType_Ct_Scope_Org = 0x8;
  static const int OCConnectivityType_Ct_Scope_Global = 0xE;

  /// IP address
  String ip = "0.0.0.0";

  /// Port
  int port = 0;

  DartivityIotivityCfg({int qos: QualityOfService_NaQos,
                       clientConnectivity: OCConnectivityType_Ct_Default,
                       String ipAddress: "0.0.0.0",
                       int port: 0}) {

    this.qualityOfService = qos;
    this.clientConnectivity = clientConnectivity;
    this.ip = ipAddress;
    this.port = port;
  }
}
