/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityCfg {

  /// Package name
  static const String MESS_PACKAGE_NAME = 'dartivity';

  /// Pubsub project id
  static const String MESS_PROJECT_ID = 'warm-actor-356';

  /// Topic for pubsub
  static const String MESS_TOPIC = "projects/${MESS_PROJECT_ID}/topics/${MESS_PACKAGE_NAME}";

  /// Client id URL
  static const String CLIENT_ID_URL = '${MESS_PACKAGE_NAME}.com';

  /// Pubsub credentials path
  static const String MESS_CRED_PATH =
  '/home/steve/Development/google/dart/projects/${MESS_PACKAGE_NAME}/credentials/Development-87fde7970997.json';


}
