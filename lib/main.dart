import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/screen/splash_screen.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/utils/helper/local_storage.dart';
import 'package:my_app/utils/theme/theme_service.dart';

import 'core/controller/login_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

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

    super.initState();
  }

  checkMode() async {
    mode = await ThemeService().getMode();
    Get.changeThemeMode(mode ? ThemeMode.dark : ThemeMode.light);
    loginCon.switchMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeService.lightMode,
      darkTheme: ThemeService.darkMode,
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
