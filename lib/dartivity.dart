/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity;

import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart' as uuid;
import 'package:dartivity_database/dartivity_database.dart' as db;
import 'package:dartivity_messaging/dartivity_messaging.dart' as mess;

part 'src/dartivity.dart';
part 'src/dartivity_iotivity.dart';
part 'src/dartivity_exception.dart';
part 'src/dartivity_cfg.dart';
part 'src/dartivity_iotivity_cfg.dart';
part 'src/dartivity_iotivity_platform.dart';

part 'src/dartivity_client_iotivity_resource.dart';

/// Mode enumeration
/// Supports only local iot resources, messaging or both.
/// Note iotOnly includes database support, messaging only
/// doesn't.
enum Mode { iotOnly, messagingOnly, both }

/// Iot client support
enum Client { iotivity, mqtt }
