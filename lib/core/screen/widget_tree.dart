import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/url_screen.dart';
import '../../utils/helper/local_storage.dart';
import 'login.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  Widget home = Scaffold();
  var user_id;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    user_id = await LocalStorage().getStringData(key: "user_id");
    debugPrint("print user_id: " + user_id);
    if (user_id.isEmpty) {
      Get.off(() => Login());
    } else {
      log(user_id.toString());
      Get.off(() => UrlScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: home,
    );
  }
}
