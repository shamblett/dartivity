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

import '../configuration/dartivity_local_conf.dart';

Future main() async {
  // Configuration
  final cfg = DartivityCfg(
      DartivityLocalConf.projectid,
      DartivityLocalConf.credentialsPath,
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);
  // Dont tail uuids for testing, we will then always generate the
  // same resource id's for the host we are on.
  cfg.tailedUuid = false;

  // Client
  late Dartivity dartivity;

  test('Initialise ', () async {
    // Instantiate a Dartivity client and initialise for
    // both messaging and iotivity, ie a normal client configuration.
    dartivity = Dartivity(Mode.both, [Client.iotivity], cfg);

    final iotCfg =
        DartivityIotivityCfg(qos: DartivityIotivityCfg.qualityOfServiceLowQos);

    final res = await dartivity.initialise(iotCfg);
    expect(res, true);
    expect(dartivity.initialised, true);
    expect(dartivity.supports, Mode.both);
  });

  test('Close ', () {
    dartivity.close();
    expect(dartivity.initialised, false);
  });
}
