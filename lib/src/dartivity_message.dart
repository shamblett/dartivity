/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

part of dartivity;

class DartivityMessage {
  /// Pubsub topic
  String _topic = 'projects/warm-actor-356/topics/dartivity';
  String get topic => _topic;

  /// Type
  Type type;

  /// Dartivity source
  String source;

  /// Dartivity Destination
  String destination;

  /// Iotivity resource identifier
  String resourceId;

  /// Iotivity resource details
  Map<String, String> resourceDetails;
}
