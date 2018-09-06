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

import '../configuration/dartivity_local_conf.dart';

Future main() async {
  // Configuration
  final DartivityCfg cfg = new DartivityCfg(
      DartivityLocalConf.projectid,
      DartivityLocalConf.credentialsPath,
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);
  // Dont tail uuids for testing, we will then always generate the
  // same resource id's for the host we are on.
  cfg.tailedUuid = false;

  // Client
  Dartivity dartivity;
  DartivityResource res;
  DateTime resUpdated;

  // Database
  final DartivityResourceDatabase db = new DartivityResourceDatabase(
      DartivityLocalConf.dbHost,
      DartivityLocalConf.dbUser,
      DartivityLocalConf.dbPassword);

  test("Initialise", () async {
    // Instantiate a Dartivity client and initialise for
    // both messaging and iotivity, ie a normal client configuration.
    dartivity = new Dartivity(Mode.both, [Client.iotivity], cfg);

    final DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
        qos: DartivityIotivityCfg.qualityOfServiceLowQos);

    final bool res = await dartivity.initialise(iotCfg);
    expect(res, true);
    expect(dartivity.initialised, true);
    expect(dartivity.supports, Mode.both);
  });

  // Start the iotovity Simple Server now!!!
  test("Find Resources", () async {
    final List<DartivityResource> resList =
        await dartivity.findResource('', DartivityIotivity.ocRsrvdWellKnownUri);
    expect(resList, isNotNull);
    expect(resList.length, 1);
    res = resList[0];
    expect(res.clientId, dartivity.id);
    expect(res.id, isNotNull);
    expect(res.provider, providerIotivity);
    final DateTime now = new DateTime.now();
    expect(
        res.updated.millisecondsSinceEpoch <= now.millisecondsSinceEpoch, true);
    expect(res.resource, isNotNull);
    final DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    resUpdated = res.updated;
  });

  test("Find Resources - from cache", () async {
    final List<DartivityResource> resList =
        await dartivity.findResource('', DartivityIotivity.ocRsrvdWellKnownUri);
    expect(resList, isNotNull);
    expect(resList.length, 1);
    res = resList[0];
    expect(res.clientId, dartivity.id);
    expect(res.id, isNotNull);
    expect(res.provider, providerIotivity);
    final DateTime now = new DateTime.now();
    expect(
        res.updated.millisecondsSinceEpoch <= now.millisecondsSinceEpoch, true);
    expect(res.resource, isNotNull);
    final DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    expect(
        res.updated.millisecondsSinceEpoch, resUpdated.millisecondsSinceEpoch);
  });

  test("Find Resources - clear cache", () async {
    dartivity.clearCache();
    final List<DartivityResource> resList =
        await dartivity.findResource('', DartivityIotivity.ocRsrvdWellKnownUri);
    expect(resList, isNotNull);
    expect(resList.length, 1);
    res = resList[0];
    expect(res.clientId, dartivity.id);
    expect(res.id, isNotNull);
    expect(res.provider, providerIotivity);
    final DateTime now = new DateTime.now();
    expect(
        res.updated.millisecondsSinceEpoch <= now.millisecondsSinceEpoch, true);
    expect(res.resource, isNotNull);
    final DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    resUpdated = res.updated;
  });

  test("Check database", () async {
    DartivityResource dbRes = await db.get(res.id);
    expect(dbRes, isNotNull);
    expect(dbRes.provider, providerIotivity);
    final DartivityIotivityResource iotRes = res.resource;
    expect(iotRes.uri, '/a/light');
    expect(iotRes.id, '/a/light');
    expect(iotRes.host.contains('coap'), true);
    expect(iotRes.observable, true);
    expect(
        res.updated.millisecondsSinceEpoch, resUpdated.millisecondsSinceEpoch);
    final bool done = await db.delete(res);
    expect(done, true);
    dbRes = await db.get(res.id);
    expect(dbRes, isNull);
  });

  test("Close", () {
    dartivity.close();
    expect(dartivity.initialised, false);
  });
}
