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

  // Find all resources

  // Should find three in standard configuration
  String requestUri = "/oic/res";
  DartivityIotivityResource foundResource = await dartivity.findResource("", requestUri);
  if (foundResource == null) {
    print("Dartivity - Dartivity Test Harness >> - No resource found FAIL");
  }

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
      "Dartivity - Dartivity Test Harness >> Resource Types are ${resTypes.toString()} ");

  // Interface types
  List<String> intTypes = foundResource.interfaceTypes;
  print(
      "Dartivity - Dartivity Test Harness >> Interface Types are ${intTypes.toString()} ");

  // Observable
  bool observable = foundResource.observable;
  print(
      "Dartivity - Dartivity Test Harness >> is resource observable ${observable.toString()}");

  DartivityIotivityResource foundResource2 = await dartivity.findResource("", requestUri);
  if (foundResource2 == null) {
    print("Dartivity - Dartivity Test Harness >> - No resource found FAIL");
  }

  // Unique Id
  String id2 = foundResource2.identifier;
  print("Dartivity - Dartivity Test Harness >> Resource unique id2 is ${id2} ");

  // Sid
  String sid2 = foundResource2.sid;
  print("Dartivity - Dartivity Test Harness >> Resource sid2 is ${sid2} ");

  // Host
  String host2 = foundResource2.host;
  print("Dartivity - Dartivity Test Harness >> Resource host2 is ${host2} ");

  // URI
  String uri2 = foundResource2.uri;
  print("Dartivity - Dartivity Test Harness >> Resource uri2 is ${uri2} ");

  // Resource types
  List<String> resTypes2 = foundResource2.resourceTypes;
  print(
      "Dartivity - Dartivity Test Harness >> Resource Types2 are ${resTypes2.toString()} ");

  // Interface types
  List<String> intTypes2 = foundResource2.interfaceTypes;
  print(
      "Dartivity - Dartivity Test Harness >> Interface Types2 are ${intTypes2.toString()} ");

  // Observable
  bool observable2 = foundResource2.observable;
  print(
      "Dartivity - Dartivity Test Harness >> is resource observable2 ${observable2.toString()}");


  // Close down
  dartivity.close();
}
