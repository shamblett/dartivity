/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:async';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_database/dartivity_database.dart';
import 'package:test/test.dart';

import '../configuration/local.dart';

Future main() async {
  // Configuration
  DartivityCfg cfg = new DartivityCfg(
      DartivityLocalConf.PROJECT_ID,
      DartivityLocalConf.CRED_PATH,
      DartivityLocalConf.DBHOST,
      DartivityLocalConf.DBUSER,
      DartivityLocalConf.DBPASS);

  // Client
  Dartivity dartivity;

  test("Initialise", () async {
    // Instantiate a Dartivity client and initialise for
    // both messaging and iotivity, ie a normal client configuration.
    dartivity = new Dartivity(Mode.both, [Client.iotivity], cfg);

    DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
        qos: DartivityIotivityCfg.QualityOfService_LowQos);

    bool res = await dartivity.initialise(iotCfg);
    expect(res, true);
    expect(dartivity.initialised, true);
    expect(dartivity.supports, Mode.both);
  });

  // Start the iotovity Simple Server now!!!
  test("Find Resources", () async {
    List<DartivityResource> resList =
    await dartivity.findResource('', '/oic/res');
    expect(resList, isNotNull);
    expect(resList.length, 1);
    DartivityResource res = resList[0];
    expect(res.clientId, dartivity.id);
    expect(res.id, isNotNull);
    expect(res.provider, providerIotivity);
    DateTime now = new DateTime.now();
    expect(
        res.updated.millisecondsSinceEpoch <= now.millisecondsSinceEpoch, true);
    expect(res.resource, isNotNull);
    DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host, 'coap://[fe80::21e:4fff:fe20:45a3]:39450');
    expect(iotRes.observable, true);
  });
}
