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

Future main() async {
  // Instantiate a Dartivity client and initialise for
  // messaging only
  Dartivity dartivity = new Dartivity(Mode.messagingOnly);
  await dartivity.initialise(
      '/home/steve/Development/google/dart/projects/dartivity/credentials/Development-87fde7970997.json',
      'warm-actor-356');
  print("Initialse Status is ${dartivity.initialised}");

  // Send a whoHas message
  Map resourceDetails = {"resourceId": "/light"};
  DartivityMessage whoHas =
      new DartivityMessage.whoHas(dartivity.id, resourceDetails);
  dartivity.send(whoHas);

  // Listen for a message
  dartivity.nextMessage.listen((DartivityMessage message) {
    print("Message received ${message.toString()}");
    dartivity.close();
  });
}
