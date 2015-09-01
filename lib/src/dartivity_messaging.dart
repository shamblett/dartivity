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

  /// PubSub client
  pubsub.PubSub _pubsub;

  DartivityMessaging();

  /// initialise
  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  ///
  /// credentialsFile - Path to the credentials file
  /// which should be in JSON format
  /// projectName - The project name
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

    _initialised = true;
    return _initialised;
  }
}
