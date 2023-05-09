import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:my_app/config/dynamic_link.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/utils/helper/firebase_notification_handler.dart';
import 'package:my_app/utils/helper/local_storage.dart';
import 'package:my_app/utils/helper/notification_handler.dart';
import 'package:my_app/utils/theme/theme_service.dart';

import 'config/route.dart';
import 'core/controller/login_controller.dart';
import 'core/service_locator/get_it.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationHandler.initNotification();
//   print("Handling a background message: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHandler().initNotification();
  NotificationHandler.requestIOSPermissions();
  await LocalStorage().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //off rotation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //----------------------------------------------------------------//
  firebaseNotificationHandler.getFirebaseMessagingToken();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  configureDependencies();
  runApp(const MyApp());
}

CollectionReference notifications =
    FirebaseFirestore.instance.collection('notifications');
Future<void> updateBadge(RemoteMessage message) async {
  // for IOS we don't need to initializeApp for firebase
  // but for android it's doesn't work if don't initializeApp
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  // var data = message.data['data'];
  notifications.add({
    'title': message.data['title'], // John Doe
    'body': message.data['body'], // Stokes and Sons
    'isRead': false,
    'ref_id': message.data['ref_id']
    // ignore: body_might_complete_normally_catch_error
  }).catchError((error) {
    debugPrint('Failed to add user: $error');
  });
  notifications.where("isRead", isEqualTo: false).get().then((value) {
    FlutterAppBadger.updateBadgeCount(value.docs.length);
  });
  // FirebaseNotifications.showNotification(data['title'], data['body']);
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  updateBadge(message);
}

//----------------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mode;
  final loginCon = Get.put(LoginController());

  @override
  void initState() {
    checkMode();
    DynamicLink().initDynmicLink();
    super.initState();
  }

  checkMode() async {
    mode = await ThemeService().getMode();
    Get.changeThemeMode(mode ? ThemeMode.dark : ThemeMode.light);
    loginCon.switchMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    NotificationHandler.myContext = context;
    return GetMaterialApp.router(
      theme: ThemeService.lightMode,
      darkTheme: ThemeService.darkMode,
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
