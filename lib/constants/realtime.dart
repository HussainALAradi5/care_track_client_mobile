/// STOMP destinations and timings; keep the destinations in step with the server's StompDestinations.
class Realtime {
  const Realtime._();

  static const notificationsQueue = '/user/queue/notifications';
  static const readStateQueue = '/user/queue/notification-read-state';
  static const chatQueue = '/user/queue/chat';
  static const authorizationHeader = 'Authorization';
  static const bearerPrefix = 'Bearer ';
  static const reconnectDelay = Duration(seconds: 5);
  static const heartbeat = Duration(seconds: 20);
}
