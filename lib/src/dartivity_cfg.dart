/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityCfg {
  DartivityCfg(String? projectId, String? credPath, String dbHost, String dbUser,
      String dbPass) {
    _projectId = projectId;
    _credPath = credPath;
    _topic = "projects/${projectId}/topics/${packageName}";
    _dbHost = dbHost;
    _dbUser = dbUser;
    _dbPass = dbPass;
  }

  /// Package name
  static const String packageName = 'dartivity';

  /// Pubsub project id
  String? _projectId;

  String? get projectId => _projectId;

  /// Topic for pubsub
  String? _topic;

  String? get topic => _topic;

  /// Client id URL
  String _clientIdURL = '${packageName}.com';

  String get clientIdURL => _clientIdURL;

  /// Pubsub credentials path
  String? _credPath;

  String? get credPath => _credPath;

  /// Time between message pull requests
  static const int messPullTimeInterval = 10;

  // seconds

  /// Housekeeping timer
  static const int bookkeepingTimeInterval = 1;

  // seconds

  /// Use tailed uuid
  /// Adds a unique prefix to a uuid to allow more than one client on the same
  /// platform to generate different subscriptions.
  bool tailedUuid = true;

  /// Database credentials
  String? _dbUser;

  String? get dbUser => _dbUser;
  String? _dbHost;

  String? get dbHost => _dbHost;
  String? _dbPass;

  String? get dbPass => _dbPass;
}
