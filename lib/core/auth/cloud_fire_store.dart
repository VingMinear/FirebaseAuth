import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_app/model/user_model/user_model.dart';

class CloudFireStore extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var listUsers = <UserModel>[].obs;
  var loading = false.obs;
  onClear() {
    listUsers.clear();
  }

  Future<List<UserModel>> getDataFromFireStore() async {
    onClear();
    try {
      loading(true);

      await _firebaseFirestore.collection("users").get().then(
        (value) {
          value.docs.map((e) {
            var data = UserModel.fromJson(e.data());
            listUsers.add(data);
          }).toList();
        },
      );
      debugPrint("Information User :${listUsers}");
      loading(false);
    } on FirebaseException catch (e) {
      debugPrint(e.code.toString());
    }
    return listUsers;
  }

  Future<UserModel> getDataByID() async {
    UserModel data = UserModel();
    try {
      await _firebaseFirestore.doc('LwoIP46FNE7hvkLYNa8a').get().then((value) {
        data = UserModel.fromJson(value.data()!);
      });
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in getDataByID this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in getDataByID this is error : >> $error',
      );
    }
    return data;
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
