import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_app/screens/profile_screen.dart';

import '../../utils/helper/local_storage.dart';
import '../auth/authentication.dart';

class LoginController extends GetxController {
  var txtEmail = TextEditingController();
  var txtPass = TextEditingController();
  var textBtn = "LogIn".obs;
  var isEmailCorrect = false.obs;
  var isPassCorrect = false.obs;
  var loading = false.obs;
  var loadingSplashScreen = false.obs;
  var switchMode = false.obs;
  void onClear() {
    isPassCorrect(false);
    isEmailCorrect(false);
    txtEmail.text = "";
    txtPass.text = "";
  }

  Future<void> loginSuccess(bool login) async {
    loading(true);
    if (login) {
      debugPrint("User : ${Authentication().currentUser}");
      var user_id = await Authentication().currentUser?.uid;
      LocalStorage().storeData(
        key: "user_id",
        value: user_id,
      );
      await Future.delayed(
        const Duration(milliseconds: 800),
        () {
          onClear();
          Get.off(ProfileScreen());
        },
      );
    } else {
      debugPrint("cannot login");
    }
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        loading(false);
      },
    );
  }
}
