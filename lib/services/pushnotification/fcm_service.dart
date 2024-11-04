// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static void FirebasInit() {
    FirebaseMessaging.onMessage.listen(
      (Message) {
        print(Message.notification!.title);
        print(Message.notification!.body);
      },
    );
  }
}
