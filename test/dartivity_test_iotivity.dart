/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:async';
import 'dart:io';

import 'package:dartivity/dartivity.dart';

Future main() async {
  final int badExitCode = -1;

  // Instantiate a Dartivity client and initialise for
  // Iotivity only
  Dartivity dartivity = new Dartivity(Mode.iotOnly);

  // Initialise
  DartivityIotivityCfg iotCfg = new DartivityIotivityCfg(
      qos: DartivityIotivityCfg.QualityOfService_LowQos);

  await dartivity.initialise("", "", iotCfg);

  if (dartivity.initialised) {
    print("Initialse Status is true - OK");
  } else {
    print("Oops Initialse Status is false - ERROR");
    exit(badExitCode);
  }

  // At this point we need an iotivity server, see thhe simpleserver in
  // resource/examples from the iotivity code and start it.

  // Find a resource

  // None found
  String requestUri = "/oic11/res";
  List<DartivityIotivityResource> foundResourceList =
  await dartivity.findResource("", requestUri);
  if (foundResourceList != null) {
    print(foundResourceList.toString());
  } else {
    print("Dartivity - Dartivity Test Harness >> - No resource found OK PASS");
  }

  // Should find one
  requestUri = "/oic/res";
  foundResourceList = await dartivity.findResource("", requestUri);
  if (foundResourceList == null) {
    print("Dartivity - Dartivity Test Harness >> - No resource found FAIL");
  }

  foundResourceList.forEach((foundResource) {
    // Unique Id
    String id = foundResource.identifier;
    print("Dartivity - Dartivity Test Harness >> Resource unique id is ${id} ");

    // Sid
    String sid = foundResource.sid;
    print("Dartivity - Dartivity Test Harness >> Resource sid is ${sid} ");

    // Host
    String host = foundResource.host;
    print("Dartivity - Dartivity Test Harness >> Resource host is ${host} ");

    // URI
    String uri = foundResource.uri;
    print("Dartivity - Dartivity Test Harness >> Resource uri is ${uri} ");

    // Resource types
    List<String> resTypes = foundResource.resourceTypes;
    print(
        "Dartivity - Dartivity Test Harness >> Resource Types are ${resTypes
            .toString()} ");

    // Interface types
    List<String> intTypes = foundResource.interfaceTypes;
    print(
        "Dartivity - Dartivity Test Harness >> Interface Types are ${intTypes
            .toString()} ");

    // Observable
    bool observable = foundResource.observable;
    print(
        "Dartivity - Dartivity Test Harness >> is resource observable ${observable
            .toString()}");

    // To Json
    String json = foundResource.toJson();
    print("Dartivity - Dartivity Test Harness >> As JSON ${json}");
  });

  // Close down
  dartivity.close();
}
