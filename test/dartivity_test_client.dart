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
  // Dont tail uuids for testing, we will then always generate the
  // same resource id's for the host we are on.
  cfg.tailedUuid = false;

  // Client
  Dartivity dartivity;
  DartivityResource res;
  DateTime resUpdated;

  // Database
  DartivityResourceDatabase db = new DartivityResourceDatabase(
      DartivityLocalConf.DBHOST,
      DartivityLocalConf.DBUSER,
      DartivityLocalConf.DBPASS);

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
    await dartivity.findResource('', DartivityIotivity.OC_RSRVD_WELL_KNOWN_URI);
    expect(resList, isNotNull);
    expect(resList.length, 1);
    res = resList[0];
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
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    resUpdated = res.updated;
  });

  /*test("Find Resources - from cache", () async {
    List<DartivityResource> resList =
    await dartivity.findResource('', DartivityIotivity.OC_RSRVD_WELL_KNOWN_URI);
    expect(resList, isNotNull);
    expect(resList.length, 1);
    res = resList[0];
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
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    expect(res.updated.millisecondsSinceEpoch, resUpdated.millisecondsSinceEpoch);
  });*/

  test("Check database", () async {
    DartivityResource dbRes = await db.get(res.id);
    expect(dbRes, isNotNull);
    expect(dbRes.provider, providerIotivity);
    DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    expect(
        res.updated.millisecondsSinceEpoch, resUpdated.millisecondsSinceEpoch);
    /*bool done = await db.delete(res);
    expect(done, true);
    dbRes = await db.get(res.id);
    expect(dbRes, isNull);*/
  });
  test("Close", () {
    dartivity.close();
    expect(dartivity.initialised, false);
  });
}
