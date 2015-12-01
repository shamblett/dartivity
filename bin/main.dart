/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

import 'dart:async';
import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_messaging/dartivity_messaging.dart' as mess;

Future main() async {
  final int badExitCode = -1;

  // Instantiate a Dartivity client and initialise for
  // both messaging and iotivity, ie a normal client configuration.
  Dartivity dartivity = new Dartivity(Mode.both);

  DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      qos: DartivityIotivityCfg.QualityOfService_LowQos);

  await dartivity.initialise(
      DartivityCfg.MESS_CRED_PATH, DartivityCfg.MESS_PROJECT_ID,
      DartivityCfg.MESS_TOPIC, iotCfg);

  if (dartivity.initialised) {
    print("Dartivity Main - Initialse Status is true - OK");
  } else {
    print("Dartivity Main - Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }
  print("Dartivity Main - client id is ${dartivity.id}");

  // Message monitoring
  var subscription = dartivity.nextMessage.listen((
      mess.DartivityMessage message) {
    print("Dartivity Main - Message received ${message.toString()}");
  });

}