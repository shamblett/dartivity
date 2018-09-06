/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 06/09/2018
 * Copyright :  S.Hamblett 2018
 */

class DartivityLocalConf {
  /// Version
  static const String version = '0.2.0';

  /// Package name
  static const String packageName = 'dartivity';

  /// Pubsub project id
  static const String projectid = 'warm-actor-356';

  /// Topic for pubsub
  static const String messageTopic =
      "projects/${projectid}/topics/${packageName}";

  /// Pubsub credentials path
  static const String credentialsPath =
      'credentials\\Development-5d8666050474.json';

  /// Database
  static const String dbHost = 'localhost';
  static const String dbUser = 'steve';
  static const String dbPassword = 'setacrepes';
}
