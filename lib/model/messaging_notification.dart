import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initNotification() {
    // Handle Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.body}");
      // Handle the message inside the app
    });

    // Handle Background and Terminated message when the app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.notification?.body}");
      // Navigate to the specific screen or handle the message
    });

    // Handle Terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App opened from terminated state: ${message.notification?.body}");
        // Handle navigation or perform actions based on the message data
      }
    });

    // Request permission for iOS
    _firebaseMessaging.requestPermission();
  }
}
