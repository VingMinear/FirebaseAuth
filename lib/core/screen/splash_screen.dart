import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app/config/route.dart';
import 'package:my_app/core/controller/login_controller.dart';

import '../../utils/helper/local_storage.dart';
import '../../utils/helper/permission.dart';
import '../auth/cloud_fire_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user_id;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 5500),
      () {
        checkUser();
      },
    );
    super.initState();
  }

  Future<void> checkUser() async {
    user_id = await LocalStorage().getStringData(key: "user_id");
    debugPrint("print user_id: " + user_id);
    if (user_id.isEmpty) {
      router.go('/login');
    } else {
      LoginController.userInformation = await CloudFireStore.getUser(
        docId: user_id,
      );
      LoginController().updatePhoto();
      router.go('/profile');
    }
    await PermissionService.askPermissionNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        "assets/splash.json",
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        repeat: false,
        onLoaded: (p0) {
          print("loead${p0.duration}");
        },
      ),
    );
  }
}
