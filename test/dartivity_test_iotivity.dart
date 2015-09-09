/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:async';
import 'dart:io';

import 'package:dartivity/dartivity.dart';

Future main() async {
  final int badExitCode = -1;

  // Instantiate a Dartivity client and initialise for
  // Iotivity only
  Dartivity dartivity = new Dartivity(Mode.iotOnly);

  // Initialise
  DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      DartivityIotivityCfg.ServiceType_InProc,
      DartivityIotivityCfg.ModeType_Both,
      qos: DartivityIotivityCfg.QualityOfService_LowQos,
      dbFile:
      "/home/steve/Development/iot/iotivity/sources/git/resource/examples/oic_svr_db_client.json");

  await dartivity.initialise("", "", iotCfg);

  if (dartivity.initialised) {
    print("Initialse Status is true - OK");
  } else {
    print("Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }
}
