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

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
      expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
    });

    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null);
      expect(dartivity.initialised, false);
    });
  });
}
