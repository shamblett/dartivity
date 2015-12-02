/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_messaging/dartivity_messaging.dart';
import 'package:dartivity_database/dartivity_database.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:json_object/json_object.dart' as jsonobject;

void main() {
  group("Construction and configuration", () {
    test("No mode supplied", () {
      Dartivity dartivity = new Dartivity(null, null);
      expect(dartivity.supports, Mode.both);
    });

    test("Both mode", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.supports, Mode.both);
    });

    test("Messaging only mode", () {
      Dartivity dartivity = new Dartivity(Mode.messagingOnly, null);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test("Iotivity client", () {
      Dartivity dartivity = new Dartivity(Mode.both, [Client.iotivity]);
      expect(dartivity.supports, Mode.iotOnly);
    });

    test("Hostname", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
      if (DartivityCfg.tailedUuid) {
        String newId = dartivity.id.split('%').first;
        expect(newId, "${Platform.localHostname}" + '-' + "${uuid1}");
      } else {
        expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
      }
    });
  });

  group("Initialisation", () {
    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null, null);
      expect(dartivity.initialised, false);
    });

    test("No send until initialised", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.send(null), null);
    });

    test("No find resource until initialised", () async {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(await dartivity.findResource(null, null), null);
    });
  });
}
