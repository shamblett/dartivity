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

  Mode get supports => _mode;

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
  Dartivity(Mode mode, [String credentialsPath, String projectName]) {
    _mode = mode;

    // Initialise depending on mode
    if (_mode == Mode.both || _mode == Mode.messagingOnly) {

      // Must have a credentials path for messaging
      if (credentialsPath == null) {
        throw new DartivityException(DartivityException.NO_CREDPATH_SPECIFIED);
      }
      _messager = new DartivityMessaging();
      _messager.initialise(credentialsPath, projectName)
        ..then((bool state) {
        if (!_messager.ready) {
          throw new DartivityException(
              DartivityException.FAILED_TO_INITIALISE_MESSAGER);
        }
      });
    }

    if (_mode == Mode.both || _mode == Mode.iotOnly) {
      _client = new DartivityClient();
      if (!_client.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_IOTCLIENT);
      }
    }

    _initialised = true;
  }
}
