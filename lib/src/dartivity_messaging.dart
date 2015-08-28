/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of  dartivity;

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

  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  ///
  void initialise(String credentialsFile) {


  }
}