import 'package:firebase_messaging/firebase_messaging.dart';

class MessageManager {
  final FirebaseMessaging _messaging;

  MessageManager(this._messaging);

  Future<String> getToken() => _messaging.getToken();

  Stream<String> get tokenStream => _messaging.onTokenRefresh;

  Future subscribe(String topic) => _messaging.subscribeToTopic(topic);

  Future unsubscribe(String topic) => _messaging.unsubscribeFromTopic(topic);
}