import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late FirebaseMessaging messaging;
  String? token = "";

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Lấy token của thiết bị
    messaging.getToken().then((value) {
      print("🔑 Token thiết bị: $value");
      setState(() {
        token = value;
      });
    });

    // Khi app đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Thông báo foreground: ${message.notification?.title}');
      // Bạn có thể hiển thị dialog/snackbar ở đây
    });

    // Khi user nhấn vào thông báo để mở app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('👆 User nhấn thông báo: ${message.notification?.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông báo Firebase")),
      body: Center(child: SelectableText("Token của bạn:\n$token")),
    );
  }
}
