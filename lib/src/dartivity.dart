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

  bool _messagerInitialised = false;
  bool _clientInitialised = false;

  /// Initialised
  bool get initialised {
    switch (_mode) {
      case Mode.both:
        return _messagerInitialised && _clientInitialised;
        break;
      case Mode.messagingOnly:
        return _messagerInitialised;
        break;
      case Mode.iotOnly:
        return _clientInitialised;
        break;
    }
  }

  /// Iotivity client
  DartivityClient _client;

  /// Messaging client
  DartivityMessaging _messager;

  /// Dartivity client
  /// mode - the operational mode of the client
  Dartivity(Mode mode) {
    _mode = mode;
  }

  /// initialise
  ///
  /// credentialsPath - path to a valid credentials file for messaging
  /// projectName - project name for messaging.
  Future<bool> initialise([String credentialsPath, String projectName]) async {
    // Initialise depending on mode
    if (_mode == Mode.both || _mode == Mode.messagingOnly) {
      // Must have a credentials path for messaging
      if (credentialsPath == null) {
        throw new DartivityException(DartivityException.NO_CREDPATH_SPECIFIED);
      }
      // Must have a project name for messaging
      if (credentialsPath == null) {
        throw new DartivityException(
            DartivityException.NO_PROJECTNAME_SPECIFIED);
      }
      _messager = new DartivityMessaging();
      await _messager.initialise(credentialsPath, projectName);
      if (!_messager.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_MESSAGER);
      }
      _messagerInitialised = true;
      return _messagerInitialised;
    }

    if (_mode == Mode.both || _mode == Mode.iotOnly) {
      _client = new DartivityClient();
      if (!_client.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_IOTCLIENT);
      }
      _clientInitialised = true;
      return _clientInitialised;
    }
  }
}
