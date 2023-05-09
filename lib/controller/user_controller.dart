import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/config/route.dart';
import 'package:my_app/model/user_model/members.dart';

class UserController extends GetxController {
  var name = TextEditingController();
  var email = TextEditingController();
  var loading = false.obs;

  var age = TextEditingController();

  static final CollectionReference _members =
      FirebaseFirestore.instance.collection("members");
  onClear() {
    name.text = "";
    email.text = "";
    age.text = "";
  }

  Future<void> addMembers({
    required String docId,
    required MembersModel membersInfo,
  }) async {
    loading(true);
    try {
      debugPrint("docID:$docId");
      // db.collection("cities").doc("new-city-id").set({"name": "Chicago"});
      await _members.doc(docId).set({
        "id": membersInfo.id,
        "email": membersInfo.email,
        "name": membersInfo.name,
        "age": membersInfo.age,
      }).then((val) {
        debugPrint("SUCCESS");
        onClear();
        router.pop();
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
    Future.delayed(
      const Duration(milliseconds: 400),
      () {
        loading(false);
      },
    );
  }

  Future<void> removeMemberes({
    required String docId,
  }) async {
    try {
      _members.doc(docId).delete().then((value) {
        debugPrint("delete item successfully");
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
