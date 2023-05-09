import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> askPermissionNotification() async {
    debugPrint("askPermissionNotification-->");
    await Permission.notification.isDenied.then((value) {
      Permission.notification.request();
      debugPrint("permission $value");
      if (value) {
        Permission.notification.request();
      }
    });
  }
}
