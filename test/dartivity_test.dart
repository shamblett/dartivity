/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:async';

import 'package:dartivity/dartivity.dart';
import 'package:test/test.dart';

Future main() async {
  // Instantiate a Dartivity client and initialise for
  // messaging only
  Dartivity dartivity = new Dartivity(Mode.messagingOnly);
  await dartivity.initialise(
      DartivityCfg.MESS_CRED_PATH,
      DartivityCfg.MESS_PROJECT_ID);
  print("Initialse Status is ${dartivity.initialised}");

  // Send a couple of whoHas messages
  DartivityMessage whoHas1 =
  new DartivityMessage.whoHas(dartivity.id, '/core/light');
  dartivity.send(whoHas1);
  DartivityMessage whoHas2 =
  new DartivityMessage.whoHas(dartivity.id, '/core/thrmostat');
  dartivity.send(whoHas2);

  // Listen for a message until our timer pops
  var subscription;

  void timerCallback() {
    print("Closing the client");
    subscription.cancel();
    try {
      dartivity.close();
    } catch (e) {
    }
  }
  Timer timer = new Timer(new Duration(seconds: 45), timerCallback);
  subscription = dartivity.nextMessage.listen((DartivityMessage message) {
    print("Message received ${message.toString()}");
  });
}
