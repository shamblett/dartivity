/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity;

import 'dart:io';
import 'dart:async';

import 'package:gcloud/pubsub.dart' as pubsub;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:uuid/uuid.dart' as uuid;

part 'src/dartivity.dart';
part 'src/dartivity_client.dart';
part 'src/dartivity_messaging.dart';
part 'src/dartivity_exception.dart';
part 'src/dartivity_message.dart';

/// Mode enumeration
/// Supports only iotivity server, messaging or both
enum Mode {
  iotOnly, messagingOnly, both
}

/// Message types
enum Type {
  whoHas,
  iHave,
  resourceInfo
}

