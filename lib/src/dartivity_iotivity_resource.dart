/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityIotivityResource {
  /// Resource identifier
  ///
  /// This will be guaranteed unique for every resource-per-server
  /// independent of how this was discovered.
  String identifier;

  /// Host
  String host;

  /// Uri
  String uri;

  /// Server identifier
  ///
  /// a string representation of the resource's server ID.
  /// This is unique per- server independent on how it was discovered.
  String sid;

  DartivityIotivityResource(String id, String host, String Uri, String sid) {
    this.identifier = id;
    this.host = host;
    this.uri = uri;
    this.sid = sid;
  }
}
