import 'package:firebase_messaging/firebase_messaging.dart';

class Api {
  final _firebaseMessageing = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessageing.requestPermission();
    final fcmToken = await _firebaseMessageing.getToken();
    print("Token: $fcmToken");
  }
}
