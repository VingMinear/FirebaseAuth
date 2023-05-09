import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/core/auth/cloud_fire_store.dart';
import 'package:my_app/core/controller/login_controller.dart';
import 'package:my_app/model/user_model/user_model.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  static snackBarError(String message) {
    Get.snackbar(
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(milliseconds: 1500),
      "Ops Sorry",
      "${message}",
    );
  }

  static snackBarSuccess({required String title, required String message}) {
    Get.snackbar(
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(milliseconds: 1500),
      title,
      message,
    );
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUser!.providerData.asMap().entries.map((e) {
        debugPrint("Value use : ${e.value}");
      }).toList();
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithEmailAndPassword this is error : >> ${error.message!.trim()}',
      );
      snackBarError(error.code);
      return false;
    }
  }

  // Future<void> signInWithGoole()async{
  //   await _firebaseAuth.
  // }
  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userInfo = LoginController.getUserInforAfterLogin();
      await CloudFireStore().addUserInformation(
        docId: currentUser!.uid,
        userInfo: userInfo,
      );
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when createUserWithEmailAndPassword this is error : >> $error',
      );
      snackBarError(error.code);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError in signOut this is error : >> $error',
      );
    }
  }

  resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithCredential this is error : >> $error',
      );
      snackBarError(error.code);
      return false;
    }
  }

  Future<bool> signInWithCredential({
    required AuthCredential credential,
  }) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithCredential this is error : >> $error',
      );
      snackBarError(error.code);
      return false;
    }
  }
}

// class User {
//   String? email;
//   String? password;
//   User({
//     this.email,
//     this.password,
//   });
// }
