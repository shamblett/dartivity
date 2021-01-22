/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

@TestOn('vm ')

library dartivity.test;

import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../configuration/dartivity_local_conf.dart';

void main() {
  // Configuration
  final cfg = DartivityCfg(
      DartivityLocalConf.projectid,
      DartivityLocalConf.credentialsPath,
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);

  group('Construction and configuration ', () {
    test('No mode supplied ', () {
      final dartivity = Dartivity(null, null, cfg);
      expect(dartivity.supports, Mode.both);
    });

    test('Both mode ', () {
      final dartivity = Dartivity(Mode.both, null, cfg);
      expect(dartivity.supports, Mode.both);
    });

    test('Messaging only mode ', () {
      final dartivity = Dartivity(Mode.messagingOnly, null, cfg);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test('Iotivity client ', () {
      final dartivity = Dartivity(Mode.both, [Client.iotivity], cfg);
      expect(dartivity.supports, Mode.both);
      expect(dartivity.clientList![0], Client.iotivity);
    });

    test('Hostname ', () {
      final dartivity = Dartivity(Mode.both, null, cfg);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test('Id generation check ', () {
      final dartivity = Dartivity(Mode.both, null, cfg);
      final myUuid = uuid.Uuid();
      final uuid1 = myUuid.v5(uuid.Uuid.NAMESPACE_URL, cfg.clientIdURL);
      if (cfg.tailedUuid) {
        final newId = dartivity.id.split('%').first;
        expect(newId, '${Platform.localHostname}-${uuid1} ');
      } else {
        expect(dartivity.id, '${Platform.localHostname}-${uuid1} ');
      }
    });
  });

  group('Initialisation ', () {
    test('Initialise - No credentials path ', () {
      try {
        final cfg = DartivityCfg(
            DartivityLocalConf.projectid,
            null,
            DartivityLocalConf.dbHost,
            DartivityLocalConf.dbUser,
            DartivityLocalConf.dbPassword);
        final dartivity = Dartivity(Mode.messagingOnly, null, cfg);
        print(dartivity);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(e.toString(),
            DartivityException.header + DartivityException.noCredpathSpecified);
      }
    });

    test('Initialise - No project id ', () {
      try {
        final cfg = DartivityCfg(
            null,
            DartivityLocalConf.credentialsPath,
            DartivityLocalConf.dbHost,
            DartivityLocalConf.dbUser,
            DartivityLocalConf.dbPassword);
        final dartivity = Dartivity(Mode.messagingOnly, null, cfg);
        print(dartivity);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.header +
                DartivityException.noProjectnameSpecified);
      }
    });

    test('Initialise state ', () {
      final dartivity = Dartivity(null, null, cfg);
      expect(dartivity.initialised, false);
    });

    test('No send until initialised ', () async {
      final dartivity = Dartivity(Mode.both, null, cfg);
      expect(await dartivity.send(null), null);
    });

    test('No find resource until initialised ', () async {
      final dartivity = Dartivity(Mode.both, null, cfg);
      expect(await dartivity.findResource(null, null), null);
    });
  });
}
