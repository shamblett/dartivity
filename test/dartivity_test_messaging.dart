/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

@TestOn("vm")

library dartivity.test;

import 'dart:async';
import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_messaging/dartivity_messaging.dart';
import 'package:test/test.dart';

import '../configuration/local.dart';

Future main() async {
  final int badExitCode = -1;

  // Configuration
  DartivityCfg cfg = new DartivityCfg(
      DartivityLocalConf.PROJECT_ID,
      DartivityLocalConf.CRED_PATH,
      DartivityLocalConf.DBHOST,
      DartivityLocalConf.DBUSER,
      DartivityLocalConf.DBPASS);

  // Instantiate a Dartivity client and initialise for
  // messaging only
  Dartivity dartivity = new Dartivity(Mode.messagingOnly, null, cfg);

  test("Send before ready", () {
    DartivityMessage noSend =
    new DartivityMessage.iHave("", "", "", {}, "", "");
    var result = dartivity.send(noSend);
    expect(result, isNull);
  });

  test("Initialise", () async {
    await dartivity.initialise();
    expect(dartivity.initialised, true);
  });

  test("Send null message", () async {
    DartivityMessage result1 = dartivity.send(null);
    expect(result1, isNull);
  });

  test("Message exchange scenario", () async {
    Completer completer = new Completer();
    // Send a couple of whoHas messages
    DartivityMessage whoHas1 =
    new DartivityMessage.whoHas(dartivity.id, '/core/light');
    String whoHas1Json = whoHas1.toJSON();
    DartivityMessage result1 = dartivity.send(whoHas1);
    expect(result1, isNotNull);
    expect(result1.type, MessageType.whoHas);
    DartivityMessage whoHas2 =
    new DartivityMessage.whoHas(dartivity.id, '/core/thermostat');
    DartivityMessage result2 = dartivity.send(whoHas2);
    expect(result2, isNotNull);
    expect(result2.type, MessageType.whoHas);
    // Followed by a I Have
    Map<String, String> myDevice = {
      'iama': 'thermostat',
      'url': 'here.com/ami'
    };
    DartivityMessage iHave = new DartivityMessage.iHave(
        dartivity.id, dartivity.id, '/core/therm/1', myDevice, "", "");
    DartivityMessage result3 = dartivity.send(iHave);
    expect(result3, isNotNull);
    expect(result3.type, MessageType.iHave);
    // Followed by a I Have but not for us
    Map<String, String> myDevice1 = {
      'iama': 'thermostat',
      'url': 'here.com/ami'
    };
    DartivityMessage iHave1 = new DartivityMessage.iHave(
        dartivity.id, 'not us', '/core/therm/1', myDevice1, "", "");
    DartivityMessage result4 = dartivity.send(iHave1);
    expect(result4, isNotNull);
    expect(result4.type, MessageType.iHave);

    // Listen for our messages until our timer pops
    var subscription;
    Timer timer;
    int messCount = 0;

    void timerCallback() {
      print("Closing the client");
      expect(messCount, 3);
      subscription.cancel();
      timer.cancel();
      dartivity.close();
      completer.complete(true);

    }
    timer = new Timer(
        new Duration(seconds: (DartivityCfg.MESS_PULL_TIME_INTERVAL * 7 + 2)),
        timerCallback);

    subscription = dartivity.nextMessage.listen((DartivityMessage message) {
      print("Message received ${message.toString()}");
      messCount++;

      return completer.future;
    });
  });
}
