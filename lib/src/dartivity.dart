/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class Dartivity {
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
    final uuid.Uuid myUuid = new uuid.Uuid();
    _uuid = myUuid.v5(uuid.Uuid.NAMESPACE_URL, cfg.clientIdURL);
    if (cfg.tailedUuid) {
      final Random rnd = new Random();
      final int rand = rnd.nextInt(1000);
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
    return false;
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
      const Duration(seconds: DartivityCfg.bookkeepingTimeInterval);

  /// Housekeep timer
  Timer _housekeepTimer;

  /// Housekeep pulse;
  int _housekeepPulse = 1;

  /// Received message stream
  final _messageRxed = new StreamController.broadcast();

  Stream get nextMessage => _messageRxed.stream;

  /// Resource cache
  db.DartivityCache _cache;

  /// Resource database
  db.DartivityResourceDatabase _database;

  /// Configuration
  DartivityCfg _cfg;

  /// initialise
  ///
  /// credentialsPath - path to a valid credentials file for messaging
  /// projectName - project name for messaging.
  Future<bool> initialise([DartivityIotivityCfg iotCfg]) async {
    // Initialise depending on mode
    if (_mode == Mode.both || _mode == Mode.messagingOnly) {
      // Must have a credentials path for messaging
      if (_cfg.credPath == null) {
        throw new DartivityException(DartivityException.noCredpathSpecified);
      }
      // Must have a project name for messaging
      if (_cfg.projectId == null) {
        throw new DartivityException(DartivityException.noProjectnameSpecified);
      }

      _messager = new mess.DartivityMessaging(id);
      await _messager.initialise(_cfg.credPath, _cfg.projectId, _cfg.topic);
      if (!_messager.ready) {
        throw new DartivityException(
            DartivityException.failedToInitialiseMessager);
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
                  DartivityException.noIotCfgSpecified);
            }
            _iotivityClient = new DartivityIotivity(id);
            await _iotivityClient.initialise(iotCfg);
            if (!_iotivityClient.ready) {
              throw new DartivityException(
                  DartivityException.failedToInitialiseIotclient);
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
  Future<mess.DartivityMessage> send(mess.DartivityMessage message) async {
    final Completer<mess.DartivityMessage> completer =
        new Completer<mess.DartivityMessage>();
    mess.DartivityMessage sentMessage;
    if (initialised && message != null) {
      sentMessage = await _messager.send(message);
    }
    completer.complete(sentMessage);
    return completer.future;
  }

  /// _receive
  ///
  /// Message receive method
  Future _receive() async {
    final completer = new Completer();
    final mess.DartivityMessage message = await _messager.receive();
    if (message != null) {
      // Filter ones we don't want to process, always add to the message
      // event stream for external listeners.
      final mess.DartivityMessage filteredMessage = _filter(message);
      if (filteredMessage != null) {
        _messageRxed.add(filteredMessage);

        // Default processing for whoHas messages
        if (filteredMessage.type == mess.MessageType.whoHas) {
          if (filteredMessage.refreshCache) clearCache();
          final List<db.DartivityResource> resourceList = await findResource(
              filteredMessage.host, filteredMessage.resourceName);
          if (resourceList != null) {
            resourceList.forEach((resource) async {
              final mess.DartivityMessage iHave =
                  new mess.DartivityMessage.iHave(
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
  Future<List<db.DartivityResource>> findResource(
      String host, String resourceName,
      [int connectivity =
          DartivityIotivityCfg.ocConnectivityTypeCtDefault]) async {
    final completer = new Completer();
    // Iotivity
    if (_iotivityClientInitialised) {
      // Check the cache
      final List<db.DartivityResource> iotivityCacheRes =
          _getAllProviderFromCache(db.providerIotivity);
      if (iotivityCacheRes.length != 0) {
        if (resourceName == DartivityIotivity.ocRsrvdWellKnownUri) {
          completer.complete(iotivityCacheRes);
        } else {
          final db.DartivityResource retRes = _cache.get(resourceName);
          if (retRes != null) {
            final List<db.DartivityResource> retList =
                new List<db.DartivityResource>();
            retList.add(retRes);
            completer.complete(retList);
          } else {
            completer.complete(null);
          }
        }
      } else {
        // Get the resources from iotivity
        final List<db.DartivityResource> iotivityResources =
            await _iotivityClient.findResource(
                host, resourceName, connectivity);
        if (iotivityResources != null) {
          // Cache and database
          _cache.bulk(iotivityResources);
          await _database.putMany(iotivityResources);
          completer.complete(iotivityResources);
        } else {
          completer.complete(null);
        }
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
      if (_housekeepPulse % DartivityCfg.messPullTimeInterval == 0) {
        await _receive();
      }
    }
    _housekeepPulse++;
  }

  /// close
  ///
  /// Close the client
  void close() {
    _messagerInitialised = false;
    _iotivityClientInitialised = false;
    _housekeepTimer.cancel();

    // Messaging
    if (_messagerInitialised) {
      _messager.close();
    }
    // Iotivity
    if (_iotivityClientInitialised) {
      _iotivityClient.close();
    }
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

  /// getAllProviderFromCache
  ///
  /// Gets all cache entries for the specified provider
  List<db.DartivityResource> _getAllProviderFromCache(String provider) {
    final List<db.DartivityResource> allRes = _cache.all().values.toList();
    if (allRes == null) return null;
    final List<db.DartivityResource> retRes = new List<db.DartivityResource>();
    allRes.forEach((res) {
      if (res.provider == provider) retRes.add(res);
    });
    return retRes;
  }

  /// clearCache
  ///
  /// Clears the cache
  void clearCache() {
    _cache.clear();
  }
}
