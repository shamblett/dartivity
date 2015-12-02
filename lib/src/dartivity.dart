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

  /// Client
  List<Client> _client;

  List<Client> get clientList => _client;

  /// State
  bool _messagerInitialised = false;
  bool _iotivityClientInitialised = false;

  /// Initialised
  bool get initialised {
    switch (_mode) {
      case Mode.both:
        return _messagerInitialised && _iotivityClientInitialised;
      case Mode.messagingOnly:
        return _messagerInitialised;
      case Mode.iotOnly:
        return _iotivityClientInitialised;
    }
  }

  /// Uuid
  String _uuid;

  /// Hostname for subscription id
  final String hostname = Platform.localHostname;

  /// Id of this dartivity client
  String get id => hostname + '-' + _uuid;

  /// Iotivity client
  DartivityIotivity _iotivityClient;

  /// Messaging client
  mess.DartivityMessaging _messager;

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

  /// Resource cache
  db.DartivityCache _cache;

  /// Resource database
  db.DartivityResourceDatabase _database;

  /// Configuration
  DartivityCfg _cfg;

  /// Dartivity
  /// mode - the operational mode of the client, defaults to both
  /// client - the clients to use
  Dartivity(Mode mode, List<Client> clients, DartivityCfg cfg) {
    if (mode == null) {
      _mode = Mode.both;
    } else {
      _mode = mode;
    }
    _client = clients;

    // Generate our namespaced uuid
    uuid.Uuid myUuid = new uuid.Uuid();
    _uuid = myUuid.v5(uuid.Uuid.NAMESPACE_URL, cfg.clientIdURL);
    if (cfg.tailedUuid) {
      Random rnd = new Random();
      int rand = rnd.nextInt(1000);
      _uuid += "%${rand.toString()}";
    }

    // Cache
    _cache = new db.DartivityCache();

    // Resource database
    _database =
    new db.DartivityResourceDatabase(cfg.dbHost, cfg.dbUser, cfg.dbPass);

    // Configuration
    _cfg = cfg;
  }

  /// initialise
  ///
  /// credentialsPath - path to a valid credentials file for messaging
  /// projectName - project name for messaging.
  Future<bool> initialise([DartivityIotivityCfg iotCfg]) async {
    // Initialise depending on mode
    if (_mode == Mode.both || _mode == Mode.messagingOnly) {
      // Must have a credentials path for messaging
      if (_cfg.credPath == null) {
        throw new DartivityException(DartivityException.NO_CREDPATH_SPECIFIED);
      }
      // Must have a project name for messaging
      if (_cfg.projectId == null) {
        throw new DartivityException(
            DartivityException.NO_PROJECTNAME_SPECIFIED);
      }

      _messager = new mess.DartivityMessaging(id);
      await _messager.initialise(_cfg.credPath, _cfg.projectId, _cfg.topic);
      if (!_messager.ready) {
        throw new DartivityException(
            DartivityException.FAILED_TO_INITIALISE_MESSAGER);
      }

      _messagerInitialised = true;
    }

    if (_mode == Mode.both || _mode == Mode.iotOnly) {
      for (Client client in _client) {
        switch (client) {
          case Client.iotivity:
          // Must have a configuration for iotivity
            if (iotCfg == null) {
              throw new DartivityException(
                  DartivityException.NO_IOT_CFG_SPECIFIED);
            }
            _iotivityClient = new DartivityIotivity(id);
            await _iotivityClient.initialise(iotCfg);
            if (!_iotivityClient.ready) {
              throw new DartivityException(
                  DartivityException.FAILED_TO_INITIALISE_IOTCLIENT);
            }
            _iotivityClientInitialised = true;
            break;

          default:
            break;
        }
      }
    }
    // Start our housekeeping timer
    _housekeepTimer = new Timer.periodic(_housekeepDuration, _houseKeep);
    return initialised;
  }

  /// send
  ///
  /// Send a Dartivity Message
  mess.DartivityMessage send(mess.DartivityMessage message) {
    if (!initialised) return null;
    if (message == null) return null;
    _messager.send(message);
    return message;
  }

  /// _receive
  ///
  /// Message receive method
  Future _receive() async {
    var completer = new Completer();
    mess.DartivityMessage message = await _messager.receive();
    if (message != null) {
      // Filter ones we don't want to process, always add to the message
      // event stream for external listeners.
      mess.DartivityMessage filteredMessage = _filter(message);
      if (filteredMessage != null) {
        _messageRxed.add(filteredMessage);

        // Default processing for whoHas messages
        if (filteredMessage.type == mess.MessageType.whoHas) {
          List<db.DartivityResource> resourceList = await findResource(
              filteredMessage.host, filteredMessage.resourceName);
          if (resourceList != null) {
            resourceList.forEach((resource) async {
              mess.DartivityMessage iHave = new mess.DartivityMessage.iHave(
                  id,
                  filteredMessage.source,
                  resource.id,
                  resource.resource.toMap(),
                  "",
                  resource.provider);
              await send(iHave);
            });
            completer.complete();
          }
        }
      }
    }
    return completer.future;
  }

  /// findResource
  Future<List<db.DartivityResource>> findResource(String host,
      String resourceName,
      [int connectivity =
          DartivityIotivityCfg.OCConnectivityType_Ct_Default]) async {
    var completer = new Completer();
    // Iotivity
    if (_iotivityClientInitialised) {
      List<db.DartivityResource> iotivityResources =
      await _iotivityClient.findResource(host, resourceName, connectivity);
      if (iotivityResources != null) {
        // Cache and database
        _cache.bulk(iotivityResources);
        await _database.putMany(iotivityResources);
        completer.complete(iotivityResources);
      } else {
        completer.complete(null);
      }
    } else {
      completer.complete(null);
    }
    return completer.future;
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

    if (_iotivityClientInitialised) {
      _iotivityClient.close();
    }

    _housekeepTimer.cancel();
  }

  ///_filter
  ///
  /// Filter out messages that are not for us
  mess.DartivityMessage _filter(mess.DartivityMessage message) {
    // Who has is for all, the others we only respond to if we are
    // the destination.
    if (message.type == mess.MessageType.whoHas) return message;
    if (message.destination != id) {
      return null;
    } else {
      return message;
    }
  }
}
