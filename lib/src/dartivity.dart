/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class Dartivity {

  /// Mode
  Mode _mode = Mode.both;
  Mode get mode => _mode;

  /// Initialised
  bool _initialised = false;
  bool get initialised => _initialised;

  /// Iotivity client
  DartivityClient _client;

  /// Messaging client
  DartivityMessaging _messager;

  /// Dartivity client
  /// mode - the operational mode of the client
  /// credentialsPath - path to a valid credentials file for messaging
  Dartivity(Mode mode, [String credentialsPath]) {
    _mode = mode;

    // Initialise depending on mode


  }
}
