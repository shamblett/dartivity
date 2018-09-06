/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

import 'dart:async';
import 'dart:io';

import 'package:dartivity/dartivity.dart';
import '../configuration/dartivity_local_conf.dart';

Future main() async {
  final int badExitCode = -1;

  // Instantiate a Dartivity client and initialise for
  // both messaging and iotivity, ie a normal client configuration.
  final DartivityCfg cfg = new DartivityCfg(
      DartivityLocalConf.projectid,
      DartivityLocalConf.credentialsPath,
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);
  final Dartivity dartivity = new Dartivity(Mode.both, [Client.iotivity], cfg);

  final DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      qos: DartivityIotivityCfg.qualityOfServiceLowQos);

  await dartivity.initialise(iotCfg);

  if (dartivity.initialised) {
    print("Dartivity Main - Initialse Status is true - OK");
  } else {
    print("Dartivity Main - Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }
  print("Dartivity Main - client id is ${dartivity.id}");

  // Message monitoring
  dartivity.nextMessage.listen((message) {
    print("Dartivity Main - Message received ${message.toString()}");
  });
}
