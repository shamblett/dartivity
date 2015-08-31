/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'package:dartivity/dartivity.dart';
import 'package:test/test.dart';

void main() {
  // Instantiate a Dartivity client and initialise for
  // messaging only
  Dartivity dartivity = new Dartivity(
      Mode.messagingOnly,
      '/home/steve/Development/google/dart/projects/dartivity/credentials/Development-87fde7970997.json',
      'Development');
  print("Initialse Status is ${dartivity.initialised}");
}
