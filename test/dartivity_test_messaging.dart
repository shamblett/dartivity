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

Future main() async {
  final int badExitCode = -1;

  // Instantiate a Dartivity client and initialise for
  // messaging only
  Dartivity dartivity = new Dartivity(Mode.messagingOnly);

  // Send before ready
  DartivityMessage noSend = new DartivityMessage.iHave("", "", "", {}, "", "");
  var result = dartivity.send(noSend);
  if (result == null) {
    print("Message not sent not ready - OK");
  } else {
    print("Oops message sent when not ready- ERROR");
    exit(badExitCode);
  }

  // Initialise
  await dartivity.initialise(
      DartivityCfg.MESS_CRED_PATH, DartivityCfg.MESS_PROJECT_ID);

  if (dartivity.initialised) {
    print("Initialse Status is true - OK");
  } else {
    print("Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }

  // Send a null message
  var result1 = dartivity.send(null);
  if (result1 == null) {
    print("Null message not sent - OK");
  } else {
    print("Oops null message sent - ERROR");
    exit(badExitCode);
  }

  // Send a couple of whoHas messages
  DartivityMessage whoHas1 =
  new DartivityMessage.whoHas(dartivity.id, '/core/light');
  String whoHas1Json = whoHas1.toJSON();
  print("Who Has 1 >> ${whoHas1Json}");
  dartivity.send(whoHas1);
  DartivityMessage whoHas2 =
  new DartivityMessage.whoHas(dartivity.id, '/core/thermostat');
  dartivity.send(whoHas2);

  // Followed by a I Have
  Map<String, String> myDevice = {'iama': 'thermostat', 'url': 'here.com/ami'};
  DartivityMessage iHave = new DartivityMessage.iHave(
      dartivity.id, dartivity.id, '/core/therm/1', myDevice, "", "");
  dartivity.send(iHave);

  // Followed by a I Have but not for us
  Map<String, String> myDevice1 = {'iama': 'thermostat', 'url': 'here.com/ami'};
  DartivityMessage iHave1 = new DartivityMessage.iHave(
      dartivity.id, 'not us', '/core/therm/1', myDevice1, "", "");
  dartivity.send(iHave1);

  // Listen for our messages until our timer pops
  var subscription;
  int messCount = 0;

  void timerCallback() {
    print("Closing the client");
    if (messCount == 3) {
      print("Message count is 3 - OK");
    } else {
      print("Message count is ${messCount} - ERROR, should be 3");
      exit(badExitCode);
    }
    subscription.cancel();
    try {
      dartivity.close();
    } catch (e) {
    }
    // Good exit
    exit(0);
  }
  Timer timer = new Timer(
      new Duration(seconds: (DartivityCfg.MESS_PULL_TIME_INTERVAL * 7 + 2)),
      timerCallback);

  subscription = dartivity.nextMessage.listen((DartivityMessage message) {
    print("Message received ${message.toString()}");
    messCount++;
  });
}
