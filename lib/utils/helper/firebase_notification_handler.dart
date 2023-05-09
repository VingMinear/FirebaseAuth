import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class firebaseNotificationHandler {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    await firebaseMessaging.getToken().then((value) {
      debugPrint("tokenn:${value}");
      if (value != null) {}
    });
  }

  StreamController controller = StreamController();

  CollectionReference notifications =
      FirebaseFirestore.instance.collection('users');
  streamNotification() {
    Stream stream = controller.stream;
    stream.listen(
      (event) {},
      cancelOnError: true,
    );
  }
}
