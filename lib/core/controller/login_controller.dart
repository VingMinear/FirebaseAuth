import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_app/config/route.dart';
import 'package:my_app/screens/profile_screen.dart';
import '../../model/user_model/user_model.dart';
import '../../utils/helper/image_picker.dart';
import '../../utils/helper/local_storage.dart';
import '../auth/authentication.dart';
import '../auth/cloud_fire_store.dart';

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

  final imageCon = Get.put(ImagePickerProvider());
  static UserModel userInformation = UserModel();
  updatePhoto() {
    imageCon.imageUrl(userInformation.photo);
  }

  Future<void> loginSuccess(bool login) async {
    loading(true);
    if (login) {
      debugPrint("User : ${Authentication().currentUser}");
      var user_id = Authentication().currentUser?.uid;
      LocalStorage().storeData(
        key: "user_id",
        value: user_id,
      );
      userInformation = LoginController.getUserInforAfterLogin();
      updatePhoto();
      await CloudFireStore().addUserInformation(
        docId: userInformation.id!,
        userInfo: userInformation,
      );
      await Future.delayed(
        const Duration(milliseconds: 800),
        () {
          onClear();
          router.go('/profile');
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

  static UserModel getUserInforAfterLogin() {
    Authentication obj = Authentication();
    return UserModel(
      email: obj.currentUser?.email ?? "",
      id: obj.currentUser?.uid ?? "",
      name: obj.currentUser?.displayName ?? "",
      photo: obj.currentUser?.photoURL ?? "",
      provide: "- -",
    );
  }
}
