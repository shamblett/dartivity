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
import 'package:dartivity_messaging/dartivity_messaging.dart';

import '../configuration/local.dart';

Future main() async {
  final int badExitCode = -1;

  DartivityCfg cfg = new DartivityCfg(DartivityLocalConf.PROJECT_ID,
      DartivityLocalConf.CRED_PATH, DartivityLocalConf.DBHOST,
      DartivityLocalConf.DBUSER, DartivityLocalConf.DBPASS);

  // Instantiate a Dartivity client and initialise for
  // both messaging and iotivity, ie a normal client configuration.
  Dartivity dartivity = new Dartivity(Mode.both, [Client.iotivity], cfg);

  DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      qos: DartivityIotivityCfg.QualityOfService_LowQos);

  await dartivity.initialise(iotCfg);

  if (dartivity.initialised) {
    print("Initialse Status is true - OK");
  } else {
    print("Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }
  print("Dartivity Test Harness >>> client id is ${dartivity.id}");

  // Message monitoring
  dartivity.nextMessage.listen((DartivityMessage message) {
    print("Dartivity Test Harness >>> Message received ${message.toString()}");
  });
}
