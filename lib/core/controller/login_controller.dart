import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var txtEmail = TextEditingController();
  var txtPass = TextEditingController();
  var textBtn = "LogIn".obs;
  var isEmailCorrect = false.obs;
  var isPassCorrect = false.obs;
  var loading = false.obs;
  var loadingSplashScreen = false.obs;
  void onClear() {
    isPassCorrect(false);
    isEmailCorrect(false);
    txtEmail.text = "";
    txtPass.text = "";
  }
}
