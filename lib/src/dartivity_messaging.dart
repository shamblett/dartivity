/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityMessaging {
  /// Authenticated
  bool _authenticated = false;

  /// Initialised
  bool _initialised = false;

  /// Ready, as in for use
  bool get ready => _authenticated && _initialised;

  /// Pubsub topic
  final String _topic = 'projects/warm-actor-356/topics/dartivity';
  String get topic => _topic;

  /// Pubsub subscription
  pubsub.Subscription _subscription;

  /// PubSub client
  pubsub.PubSub _pubsub;

  /// Dartivity client id
  String _dartivityId;

  DartivityMessaging(String dartivityId) {
    _dartivityId = dartivityId;
  }

  /// initialise
  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  ///
  /// credentialsFile - Path to the credentials file
  /// which should be in JSON format
  /// projectName - The project name(actually the google project id)
  Future<bool> initialise(String credentialsFile, String projectName) async {
    // Get the credenttials file as a string and create a credentials class
    String jsonCredentials = new File(credentialsFile).readAsStringSync();
    auth.ServiceAccountCredentials credentials =
        new auth.ServiceAccountCredentials.fromJson(jsonCredentials);
    _authenticated = true;

    // Create a scoped pubsub client with our authenticated credentials
    List<String> scopes = []..addAll(pubsub.PubSub.SCOPES);
    auth.AutoRefreshingAuthClient client =
        await auth.clientViaServiceAccount(credentials, scopes);
    _pubsub = new pubsub.PubSub(client, projectName);

    // Subscribe to our topic
    _subscription = await _pubsub.createSubscription(_dartivityId, topic);

    _initialised = true;
    return _initialised;
  }

  /// recieve
  ///
  /// Recieve a message from our subscription
  ///
  /// wait - whether to wait for a message or not, default is not
  Future<pubsub.Message> receive({wait: true}) async {
    var pullEvent = await _subscription.pull();
    await pullEvent.acknowledge();
    return pullEvent.message;
  }

  /// send
  ///
  /// Send a message to our subscription
  ///
  /// message - the message string to send
  Future send(String message) async {
    await _subscription.topic.publishString(message);
  }
}
