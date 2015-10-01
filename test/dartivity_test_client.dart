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
  // both messaging and iotivity, ie a normal client configuration.
  Dartivity dartivity = new Dartivity(Mode.both);

  DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      qos: DartivityIotivityCfg.QualityOfService_LowQos);

  await dartivity.initialise(
      DartivityCfg.MESS_CRED_PATH, DartivityCfg.MESS_PROJECT_ID, iotCfg);

  if (dartivity.initialised) {
    print("Initialse Status is true - OK");
  } else {
    print("Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }

  // Message monitoring
  var subscription = dartivity.nextMessage.listen((DartivityMessage message) {
    print(" <<<< Message received ${message.toString()}");
  });

  // Close down
  //dartivity.close();


}
