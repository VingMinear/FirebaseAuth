import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_app/config/route.dart';
import 'package:my_app/model/user_model/members.dart';
import 'package:my_app/model/user_model/user_model.dart';
import 'package:my_app/utils/helper/local_storage.dart';

import 'authentication.dart';

class CloudFireStore extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var listMembers = <MembersModel>[].obs;
  var allMembers = 0.obs;
  var loading = false.obs;

  static final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  ///hello neanea
  onClear() {
    listMembers.clear();
  }

  Future<void> addUserInformation({
    required String docId,
    required UserModel userInfo,
  }) async {
    try {
      // db.collection("cities").doc("new-city-id").set({"name": "Chicago"});
      await _users.doc(docId).set({
        "email": userInfo.email,
        "id": userInfo.id,
        "name": userInfo.name,
        "photo": userInfo.photo,
        "provide": userInfo.provide,
      }).then((val) {
        debugPrint("SUCCESS");
      });
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in addDataToFireStore this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in addDataToFireStore this is error : >> $error',
      );
    }
  }

  static late UserModel _data;
  static Future<UserModel> getUser({
    required String docId,
  }) async {
    try {
      await _users.doc(docId).get().then((value) {
        _data = UserModel.fromJson(value.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print("error in get User :$e");
      Authentication.snackBarError("Something went wrong");
      LocalStorage().clearData();
      await Authentication().signOut();
      router.go("login");
    }
    return _data;
  }

  Future<void> updateUser({
    required String docId,
    required Map<Object, Object> data,
  }) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(docId)
          .update(data)
          .then((value) => debugPrint("success update"));
    } catch (error) {
      debugPrint(
        'CatchError in getDataByID this is error : >> $error',
      );
    }
  }

  // Stream<List<UserModel>> realTime() {
  //   return _firebaseFirestore.collection("users").snapshots();
  // }

  // Future<void> getDataFromFireStore(uid) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection("users")
  //         .doc(uid)
  //         .get()
  //         .then((DocumentSnapshot snapshot) {});
  //   } on FirebaseAuthException catch (error) {
  //     debugPrint(
  //       'CatchError in getDataFromFireStore this is error : >> $error',
  //     );
  //   } catch (error) {
  //     debugPrint(
  //       'CatchError in getDataFromFireStore this is error : >> $error',
  //     );
  //   }
  // }
// Future<void> checkUser() async {
// try{
// DocumentSnapshot snap= await _firebaseFirestore.collection("users");
// }on FirebaseAuthException catch (error) {
// debugPrint('CatchError in checkUser this is error : >> $error',);
// } catch (error) {
// debugPrint('CatchError in checkUser this is error : >> $error',);
// }
// }
}
