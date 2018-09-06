/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

@TestOn("vm")

library dartivity.test;

import 'dart:async';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_messaging/dartivity_messaging.dart';
import 'package:test/test.dart';

import '../configuration/dartivity_local_conf.dart';

Future main() async {
  // Configuration
  final DartivityCfg cfg = new DartivityCfg(
      DartivityLocalConf.projectid,
      DartivityLocalConf.credentialsPath,
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);

  // Instantiate a Dartivity client and initialise for
  // messaging only
  final Dartivity dartivity = new Dartivity(Mode.messagingOnly, null, cfg);

  test("Send before ready", () async {
    final DartivityMessage noSend =
        new DartivityMessage.iHave("", "", "", {}, "", "");
    final result = await dartivity.send(noSend);
    expect(result, isNull);
  });

  test("Initialise", () async {
    await dartivity.initialise();
    expect(dartivity.initialised, true);
  });

  test("Send null message", () async {
    final DartivityMessage result1 = await dartivity.send(null);
    expect(result1, isNull);
  });

  test("Message exchange scenario", () async {
    final Completer completer = new Completer();
    // Send a couple of whoHas messages
    final DartivityMessage whoHas1 =
        new DartivityMessage.whoHas(dartivity.id, '/core/light');
    final DartivityMessage result1 = await dartivity.send(whoHas1);
    expect(result1, isNotNull);
    expect(result1.type, MessageType.whoHas);
    final DartivityMessage whoHas2 =
        new DartivityMessage.whoHas(dartivity.id, '/core/thermostat');
    final DartivityMessage result2 = await dartivity.send(whoHas2);
    expect(result2, isNotNull);
    expect(result2.type, MessageType.whoHas);
    // Followed by a I Have
    final Map<String, String> myDevice = {
      'iama': 'thermostat',
      'url': 'here.com/ami'
    };
    final DartivityMessage iHave = new DartivityMessage.iHave(
        dartivity.id,
        dartivity.id,
        '/core/therm/1',
        myDevice,
        "",
        DartivityMessage.providerIotivity);
    final DartivityMessage result3 = await dartivity.send(iHave);
    expect(result3, isNotNull);
    expect(result3.type, MessageType.iHave);
    // Followed by a I Have but not for us
    final Map<String, String> myDevice1 = {
      'iama': 'thermostat',
      'url': 'here.com/ami'
    };
    final DartivityMessage iHave1 = new DartivityMessage.iHave(
        dartivity.id,
        'not us',
        '/core/therm/1',
        myDevice1,
        "",
        DartivityMessage.providerIotivity);
    final DartivityMessage result4 = await dartivity.send(iHave1);
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
        new Duration(seconds: (DartivityCfg.messPullTimeInterval * 7 + 2)),
        timerCallback);

    subscription = dartivity.nextMessage.listen((message) {
      print("Message received ${message.toString()}");
      messCount++;

      return completer.future;
    });
  });
}
