/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityCfg {

  /// Platform status
  int OCPlatformStatus = OCPlatformStatus_PlatformUp;
  final int OCPlatformStatus_PlatformUp = 0;
  final int OCPlatformStatus_PlatformDown = 1;

  /// Advertisement status
  int OCAdvertisementStatus = OCAdvertisementStatus_None;
  final int OCAdvertisementStatus_None = 0;

  /// Service type
  int ServiceType = ServiceType_InProc;
  final int ServiceType_InProc = 0;
  final int ServiceType_OutOfProc = 1;

  /// Host Mode of Operation
  int ModeType = ModeType_Client;
  final int ModeType_Server = 0;
  final int ModeType_Client = 1;
  final int ModeType_Both = 2;

  /// Quality of Service attempts to abstract the guarantees provided by the underlying transport
  /// protocol. The precise definitions of each quality of service level depend on the
  /// implementation. In descriptions below are for the current implementation and may changed
  /// over time.
  int QualityOfService = QualityOfService_LowQos;
  final int QualityOfService_LowQos = 0;

  // Best effort
  final int QualityOfService_MidQos = 1;

  // Best effort
  final int QualityOfService_HighQos = 2;

  // Ack confirmation
  final int QualityOfService_NaQos = 3;

  // Let the stack decide

  /// Connectivity type
  int ServerConnectivity = OCConnectivityType_Ct_Default;
  int ClientConnectivity = OCConnectivityType_Ct_Default;
  final int OCConnectivityType_Ct_Default = 0;
  final int OCConnectivityType_Ct_Adapter_IP = 1 << 16;
  final int OCConnectivityType_Ct_Adapter_Gatt_Btle = 1 << 17;
  final int OCConnectivityType_Ct_Adapter_Rfcomm_Btedr = 1 << 18;
  final int OCConnectivityType_Ct_Adapter_Remote_Access = 1 << 19;
  final int OCConnectivityType_Ct_Flag_Secure = 1 << 4;
  final int OCConnectivityType_Ct_IP_Use_V6 = 1 << 5;
  final int OCConnectivityType_Ct_IP_Use_V4 = 1 << 6;
  final int OCConnectivityType_Ct_Scope_Interface = 0x1;
  final int OCConnectivityType_Ct_Scope_Link = 0x2;
  final int OCConnectivityType_Ct_Scope_Realm = 0x3;
  final int OCConnectivityType_Ct_Scope_Admin = 0x4;
  final int OCConnectivityType_Ct_Site = 0x5;
  final int OCConnectivityType_Ct_Scope_Org = 0x8;
  final int OCConnectivityType_Ct_Scope_Global = 0xE;

  /// IP address
  String ip;

  /// Port
  int port;

  /// Database file
  String dbFile;

}