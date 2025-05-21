import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  Future<void> handle(RemoteMessage message) async {
    print("🔔 Background notification received: ${message.messageId}");
    // Thêm logic xử lý khác ở đây
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService().handle(message);
}
