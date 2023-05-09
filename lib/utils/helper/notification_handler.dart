// local notification
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static late BuildContext myContext;
  static int _id = 0;
  Future<void> initNotification() async {
    _id = 0;
    var initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);
    await flutterLocalNotificationPlugin.initialize(
      initSetting,
    );
  }

  static Future<void> showNotification({
    String title = "",
    String body = "",
  }) async {
    var notiDetails = await notificationDetails();
    await flutterLocalNotificationPlugin.show(
      _id,
      title,
      body,
      notiDetails,
    );
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
    _id++;
  }

  static Future<NotificationDetails> notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel_Id',
      "Channel_title",
      priority: Priority.high,
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('logo'),
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    return notificationDetails;
  }

  static Future onSelectNotification(String? payload) {
    throw payload!;
    // print("get payload ${payload!}");
  }

  static void requestIOSPermissions() {
    flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    showDialog(
      context: myContext,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("OK"),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          )
        ],
      ),
    );
  }
}
