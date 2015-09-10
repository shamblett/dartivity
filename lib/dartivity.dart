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

import 'package:gcloud/pubsub.dart' as pubsub;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:uuid/uuid.dart' as uuid;
import 'package:json_object/json_object.dart' as jsonobject;
import 'dart-ext:native/dartivity_extension';

part 'src/dartivity.dart';
part 'src/dartivity_iotivity.dart';
part 'src/dartivity_messaging.dart';
part 'src/dartivity_exception.dart';
part 'src/dartivity_message.dart';
part 'src/dartivity_cfg.dart';
part 'src/dartivity_iotivity_cfg.dart';
part 'src/dartivity_iotivity_platform.dart';
part 'src/dartivity_iotivity_resource.dart';

/// Mode enumeration
/// Supports only iotivity server, messaging or both
enum Mode {
  iotOnly, messagingOnly, both
}

/// Message types
enum Type {
  whoHas,
  iHave,
  resourceDetails,
  clientInfo,
  unknown
}

