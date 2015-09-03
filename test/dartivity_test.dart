/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart' as uuid;

void main() {
  group("Construction and configuration", () {
    test("No mode supplied", () {
      Dartivity dartivity = new Dartivity(null);
      expect(dartivity.supports, Mode.both);
    });

    test("Both mode", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.supports, Mode.both);
    });

    test("Messaging only mode", () {
      Dartivity dartivity = new Dartivity(Mode.messagingOnly);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test("IOT only mode", () {
      Dartivity dartivity = new Dartivity(Mode.iotOnly);
      expect(dartivity.supports, Mode.iotOnly);
    });

    test("Hostname", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
      expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
    });


  });

  group("Initialisation", () {
    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null);
      expect(dartivity.initialised, false);
    });

    test("No send until initialised", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.send(null), null);
    });

  });
}
