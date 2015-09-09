/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivity {
  /// Ready, as in to use
  bool _ready = false;

  bool get ready => _ready;

  /// Platform
  DartivityIotivityPlatform _platform;

  DartivityIotivity() {

    _platform = new DartivityIotivityPlatform();
  }

  /// initialise
  /// Initialises the messaging class.
  ///
  /// Must be called before class usage
  Future<bool> initialise(DartivityIotivityCfg cfg) async {

    try {
      await _platform.configure(cfg);
      _ready = true;
    } catch (e) {
      _ready = false;
    }

    return _ready;
  }

  /// close
  void close() {
  }
}
