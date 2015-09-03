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

  /// State
  bool _messagerInitialised = false;
  bool _clientInitialised = false;

  /// Initialised
  bool get initialised {
    switch (_mode) {
      case Mode.both:
        return _messagerInitialised && _clientInitialised;
      case Mode.messagingOnly:
        return _messagerInitialised;
      case Mode.iotOnly:
        return _clientInitialised;
    }
  }

  /// Uuid
  String _uuid;

  /// Hostname for subscription id
  final String hostname = Platform.localHostname;

  /// Id of this dartivity client
  String get id => hostname + '-' + _uuid;

  /// Iotivity client
  DartivityClient _client;

  /// Messaging client
  DartivityMessaging _messager;

  /// Receive timer duration
  final Duration _rxDuration =
  const Duration(seconds: DartivityCfg.MESS_PULL_TIME_INTERVAL);

  /// Receive timer
  Timer _rxTimer;

  /// Received message stream
  final _messageRxed = new StreamController.broadcast();

  get nextMessage => _messageRxed.stream;

  /// Dartivity
  /// mode - the operational mode of the client, defaults to both
  Dartivity(Mode mode) {
    if (mode == null) {
      _mode = Mode.both;
    } else {
      _mode = mode;
    }
    // Generate our namespaced uuid
    uuid.Uuid myUuid = new uuid.Uuid();
    _uuid = myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
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
      _messager = new DartivityMessaging(id);
      await _messager.initialise(credentialsPath, projectName);
      if (!_messager.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_MESSAGER);
      }

      // Start our recieve timer
      _rxTimer = new Timer.periodic(_rxDuration, _receive);

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

  /// send
  ///
  /// Send a Dartivity Message
  void send(DartivityMessage message) {
    if (!initialised) return;
    if (message == null) return;
    String jsonMessage = message.toJSON();
    _messager.send(jsonMessage);
  }

  /// _receive
  ///
  /// Message receive method
  Future _receive(Timer timer) async {
    pubsub.Message message = await _messager.receive();
    if (message != null) {
      String messageString = message.asString;
      DartivityMessage dartivityMessage =
      new DartivityMessage.fromJSON(messageString);
      DartivityMessage filteredMessage = _filter(dartivityMessage);
      if (filteredMessage != null) _messageRxed.add(filteredMessage);
    }
  }

  /// close
  ///
  /// Close the client
  void close() {
    // Messaging
    if (_messagerInitialised) {
      _rxTimer.cancel();
      _messager.close();
    }

    if (_clientInitialised) {
      _client.close();
    }
  }

  ///_filter
  ///
  /// Filter out messages that are not for us
  DartivityMessage _filter(DartivityMessage message) {
    // Who has is for all, the others we only respond to if we are
    // the destination.
    if (message.type == Type.whoHas) return message;
    if (message.destination != id) {
      return null;
    } else {
      return message;
    }
  }
}
