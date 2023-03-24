import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/components/button.dart';
import 'package:my_app/core/auth/cloud_fire_store.dart';
import 'package:my_app/screens/add_user.dart';
import 'package:my_app/screens/url_screen.dart';

import '../controller/user_controller.dart';
import '../core/auth/authentication.dart';
import '../core/screen/login.dart';
import '../utils/helper/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final space = const SizedBox(height: 20);

class _ProfileScreenState extends State<ProfileScreen> {
  final fireStoreController = Get.put(CloudFireStore());
  final User userInfor = Authentication().currentUser!;
  var userCon = Get.put(UserController());
  final size = 110.0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    fireStoreController.getDataFromFireStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => userCon.loading.value
              ? Loading()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileUser(
                          userInfor: userInfor,
                        ),
                        TextButton(
                          child: Text("Add more user"),
                          onPressed: () {
                            Get.to(() => AddUser());
                          },
                        ),
                        // Visibility(
                        //   visible: !fireStoreController.loading.value,
                        //   child: Expanded(
                        //     child: ListView.builder(
                        //       itemCount: fireStoreController.listUsers.length,
                        //       itemBuilder: (context, index) {
                        //         var user = fireStoreController.listUsers[index];
                        //         return ListTile(
                        //           title: Text(
                        //               "$index - User name : ${user.name ?? "Unknown"}"),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        //   replacement: Loading(),
                        // ),

                        StreamBuilder(
                          stream: users.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Invalid");
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                          "${index + 1} - User name : ${snapshot.data?.docs[index]['name']}"),
                                    );
                                  },
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          fixedSize: Size(150, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "LogOut",
        ),
        onPressed: () async {
          LocalStorage().removeData(key: "user_id");
          await Authentication().signOut();
          Get.off(Login());
        },
      ),
    );
  }
}

class ProfileUser extends StatelessWidget {
  const ProfileUser({
    super.key,
    required this.userInfor,
  });

  final User userInfor;

  @override
  Widget build(BuildContext context) {
    final space = const SizedBox(height: 20);
    final size = 110.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                            userInfor.photoURL ??
                                "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg?20200418092106",
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.green.shade200,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                      userInfor.photoURL ??
                          "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg?20200418092106",
                    ),
                  ),
                ),
              ),
            ),
            Button(
              text: "Url",
              onPressed: () {
                Get.to(() => UrlScreen());
              },
            ),
          ],
        ),
        space,
        Text(
          "UserName: ${userInfor.displayName}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        space,
        Text(
          "Email: ${userInfor.email}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        space,
        Text(
          "Provide By: ",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Divider(
          height: 25,
          thickness: 1,
        ),
      ],
    );
  }
}
