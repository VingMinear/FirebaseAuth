import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/model/user_model/user_model.dart';

class UserController extends GetxController {
  var name = TextEditingController();
  var email = TextEditingController();
  var loading = false.obs;
  var id = "03";
  var photoUrl = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  onClear() {
    name.text = "";
    email.text = "";
    photoUrl.text = "";
  }

  Future<void> addUser({required UserModel userInfo}) async {
    loading(true);
    try {
      await _users.add({
        "id": id,
        "name": userInfo.name,
        "email": userInfo.email,
        "photoUrl": userInfo.photoUrl
      }).then((value) {
        print(value);
        onClear();
        Get.back();
      }).catchError((error) {
        debugPrint("error $error");
      });
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in AddUser this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in AddUser this is error : >> $error',
      );
    }
    Future.delayed(
      const Duration(milliseconds: 400),
      () {
        loading(false);
      },
    );
  }
}
