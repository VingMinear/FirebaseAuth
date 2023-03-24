import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app/screens/profile_screen.dart';

import '../../utils/helper/local_storage.dart';
import 'login.dart';

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
      Get.off(() => Login());
    } else {
      Get.off(() => ProfileScreen());
    }
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
