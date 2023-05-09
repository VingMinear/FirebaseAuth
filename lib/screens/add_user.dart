import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/components/button.dart';
import 'package:my_app/components/text_field_custom.dart';
import 'package:my_app/controller/user_controller.dart';
import 'package:my_app/core/auth/cloud_fire_store.dart';
import 'package:my_app/core/screen/login.dart';
import 'package:my_app/model/user_model/members.dart';
import 'package:my_app/screens/profile_screen.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    var userCon = Get.put(UserController());
    var cloudCon = Get.put(CloudFireStore());
    userCon.onClear();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add More User"),
      ),
      body: Obx(
        () => userCon.loading.value
            ? Loading()
            : Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      MyTextField(
                        inputController: userCon.name,
                        hintText: "User Name",
                      ),
                      space,
                      MyTextField(
                        inputController: userCon.age,
                        hintText: "age",
                      ),
                      space,
                      MyTextField(
                        inputController: userCon.email,
                        hintText: "Email",
                      ),
                      space,
                      Button(
                        text: "Add User",
                        onPressed: () {
                          var name = userCon.name.text;
                          var email = userCon.email.text;
                          var age = userCon.age.text;
                          var id = cloudCon.allMembers.value + 1;
                          debugPrint("id leng $id");
                          if (name.isNotEmpty && email.isNotEmpty) {
                            userCon.addMembers(
                              docId: id.toString(),
                              membersInfo: MembersModel(
                                name: name,
                                email: email,
                                age: age,
                                id: id.toString(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
