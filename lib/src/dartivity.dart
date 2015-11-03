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
  bool _iotClientInitialised = false;

  /// Initialised
  bool get initialised {
    switch (_mode) {
      case Mode.both:
        return _messagerInitialised && _iotClientInitialised;
      case Mode.messagingOnly:
        return _messagerInitialised;
      case Mode.iotOnly:
        return _iotClientInitialised;
    }
  }

  /// Uuid
  String _uuid;

  /// Hostname for subscription id
  final String hostname = Platform.localHostname;

  /// Id of this dartivity client
  String get id => hostname + '-' + _uuid;

  /// Iotivity client
  DartivityIotivity _iotClient;

  /// Messaging client
  DartivityMessaging _messager;

  /// Receive timer duration
  final Duration _housekeepDuration =
  const Duration(seconds: DartivityCfg.HOUSEKEEPING_TIME_INTERVAL);

  /// Housekeep timer
  Timer _housekeepTimer;

  /// Housekeep pulse;
  int _housekeepPulse = 1;

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
    if (DartivityCfg.tailedUuid) {
      Random rnd = new Random();
      int rand = rnd.nextInt(1000);
      _uuid += "%${rand.toString()}";
    }
  }

  /// initialise
  ///
  /// credentialsPath - path to a valid credentials file for messaging
  /// projectName - project name for messaging.
  Future<bool> initialise(
      [String credentialsPath,
      String projectName,
      DartivityIotivityCfg iotCfg]) async {
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

      _messagerInitialised = true;
    }

    if (_mode == Mode.both || _mode == Mode.iotOnly) {
      // Must have a configuration for iotivity
      if (iotCfg == null) {
        throw new DartivityException(DartivityException.NO_IOT_CFG_SPECIFIED);
      }
      _iotClient = new DartivityIotivity();
      await _iotClient.initialise(iotCfg);
      if (!_iotClient.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_IOTCLIENT);
      }
      _iotClientInitialised = true;
    }

    // Start our housekeeping timer
    _housekeepTimer = new Timer.periodic(_housekeepDuration, _houseKeep);
    return initialised;
  }

  /// send
  ///
  /// Send a Dartivity Message
  DartivityMessage send(DartivityMessage message) {
    if (!initialised) return null;
    if (message == null) return null;
    String jsonMessage = message.toJSON();
    _messager.send(jsonMessage);
    return message;
  }

  /// _receive
  ///
  /// Message receive method
  Future _receive() async {
    var completer = new Completer();
    pubsub.Message message = await _messager.receive();
    if (message != null) {
      String messageString = message.asString;
      DartivityMessage dartivityMessage =
      new DartivityMessage.fromJSON(messageString);

      // Filter ones we don't want to process, always add to the message
      // event stream for external listeners.
      DartivityMessage filteredMessage = _filter(dartivityMessage);
      if (filteredMessage != null) {
        _messageRxed.add(filteredMessage);

        // Default processing for whoHas messages
        if (filteredMessage.type == Type.whoHas) {
          List<DartivityIotivityResource> resourceList = await findResource(
              filteredMessage.host, filteredMessage.resourceName);
          if (resourceList != null) {
            resourceList.forEach((resource) async {
              DartivityMessage iHave = new DartivityMessage.iHave(
                  id,
                  filteredMessage.source,
                  resource.identifier,
                  resource.toMap(),
                  "");
              await send(iHave);
            });
            return completer.complete();
          }
        }
      }
    }
    return completer.future;
  }

  /// findResource
  Future<List<DartivityIotivityResource>> findResource(
      String host, String resourceName,
      [int connectivity =
      DartivityIotivityCfg.OCConnectivityType_Ct_Default]) async {
    var completer = new Completer();
    if (!_iotClientInitialised) return completer.complete(null);
    return await _iotClient.findResource(host, resourceName, connectivity);
  }

  /// House keeping
  Future _houseKeep(Timer timer) async {
    if (!initialised) return;
    if (_mode == Mode.both || _mode == Mode.messagingOnly) {
      // Check for message rx time
      if (_housekeepPulse % DartivityCfg.MESS_PULL_TIME_INTERVAL == 0) {
        await _receive();
      }
    }
    _housekeepPulse++;
  }

  /// close
  ///
  /// Close the client
  void close() {
    // Messaging
    if (_messagerInitialised) {
      _messager.close();
    }

    if (_iotClientInitialised) {
      _iotClient.close();
    }

    _housekeepTimer.cancel();
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
