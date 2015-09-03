/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityClient {
  /// Ready, as in to use
  bool _ready = false;

  bool get ready => _ready;

  DartivityClient();

  /// initialise
  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  Future<bool> initialise() async {
    _ready = true;
    return true;
  }

  /// close
  void close() {
  }
}
