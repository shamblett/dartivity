/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity;

import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:uuid/uuid.dart' as uuid;
import 'package:json_object/json_object.dart' as jsonobject;
import 'dart-ext:native/dartivity_extension';
import 'package:dartivity_database/dartivity_database.dart' as db;
import 'package:dartivity_messaging/dartivity_messaging.dart' as mess;

part 'src/dartivity.dart';
part 'src/dartivity_iotivity.dart';
part 'src/dartivity_exception.dart';
part 'src/dartivity_cfg.dart';
part 'src/dartivity_iotivity_cfg.dart';
part 'src/dartivity_iotivity_platform.dart';
part 'src/dartivity_iotivity_resource.dart';

part 'src/dartivity_resource.dart';

/// Mode enumeration
/// Supports only iotivity server, messaging or both
enum Mode {
  iotOnly, messagingOnly, both
}
