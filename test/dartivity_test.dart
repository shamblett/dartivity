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

import '../configuration/local.dart';

void main() {
  DartivityCfg cfg = new DartivityCfg(DartivityLocalConf.PROJECT_ID,
      DartivityLocalConf.CRED_PATH, DartivityLocalConf.DBHOST,
      DartivityLocalConf.DBUSER, DartivityLocalConf.DBPASS);

  group("Construction and configuration", () {
    test("No mode supplied", () {
      Dartivity dartivity = new Dartivity(null, null, cfg);
      expect(dartivity.supports, Mode.both);
    });

    test("Both mode", () {
      Dartivity dartivity = new Dartivity(Mode.both, null, cfg);
      expect(dartivity.supports, Mode.both);
    });

    test("Messaging only mode", () {
      Dartivity dartivity = new Dartivity(Mode.messagingOnly, null, cfg);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test("Iotivity client", () {
      Dartivity dartivity = new Dartivity(Mode.both, [Client.iotivity], cfg);
      expect(dartivity.supports, Mode.iotOnly);
    });

    test("Hostname", () {
      Dartivity dartivity = new Dartivity(Mode.both, null, cfg);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both, null, cfg);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, cfg.clientIdURL);
      if (cfg.tailedUuid) {
        String newId = dartivity.id.split('%').first;
        expect(newId, "${Platform.localHostname}" + '-' + "${uuid1}");
      } else {
        expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
      }
    });
  });

  group("Initialisation", () {
    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null, null, cfg);
      expect(dartivity.initialised, false);
    });

    test("No send until initialised", () {
      Dartivity dartivity = new Dartivity(Mode.both, null, cfg);
      expect(dartivity.send(null), null);
    });

    test("No find resource until initialised", () async {
      Dartivity dartivity = new Dartivity(Mode.both, null, cfg);
      expect(await dartivity.findResource(null, null), null);
    });
  });
}
