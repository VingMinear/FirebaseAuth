import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/components/button.dart';
import 'package:my_app/config/dynamic_link.dart';
import 'package:my_app/config/route.dart';
import 'package:my_app/core/auth/cloud_fire_store.dart';
import 'package:badges/badges.dart' as badges;
import 'package:my_app/core/controller/login_controller.dart';
import 'package:my_app/core/service_locator/get_it.dart';
import 'package:my_app/screens/photo_view.dart';
import 'package:my_app/utils/helper/notification_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/user_controller.dart';
import '../core/auth/authentication.dart';
import '../core/screen/login.dart';
import '../model/user_model/user_model.dart';
import '../utils/helper/image_picker.dart';
import '../utils/helper/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final space = const SizedBox(height: 20);

class _ProfileScreenState extends State<ProfileScreen> {
  final fireStoreController = Get.put(CloudFireStore());
  final userInfor = LoginController.getUserInforAfterLogin();
  var userCon = Get.put(UserController());
  final size = 110.0;
  CollectionReference members =
      FirebaseFirestore.instance.collection('members');
  @override
  void initState() {
    // fireStoreController.getDataFromFireStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => userCon.loading.value
              ? Loading()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileUser(
                        userInfor: userInfor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                Text(
                                  "Add more user",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.hand_point_left_fill,
                                  color: Theme.of(context).cardColor,
                                )
                              ],
                            ),
                            onPressed: () {
                              router.push("/adduser");
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).cardColor,
                              fixedSize: Size(90, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "LogOut",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () async {
                              LocalStorage().removeData(key: "user_id");
                              await Authentication().signOut();

                              router.go('/login');
                            },
                          ),
                        ],
                      ),
                      StreamBuilder(
                        stream: members.snapshots(),
                        builder: (context, snapshot) {
                          var data = snapshot.data?.docs.length ?? 0;
                          debugPrint("value :${data}");
                          if (snapshot.hasError) {
                            return Text("Invalid");
                          } else if (data == 0) {
                            debugPrint("show");
                            return Container(
                              margin: EdgeInsets.only(top: Get.height * .25),
                              child: Center(
                                child: Text("No Data..."),
                              ),
                            );
                          } else {
                            debugPrint("not");
                            fireStoreController.allMembers.value =
                                snapshot.data?.docs.length ?? 0;
                            debugPrint(
                                "alway update--${fireStoreController.allMembers.value}");
                            return Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data?.docs.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.red[100 * (index % 3 + 1)],
                                    child: Slidable(
                                      key: Key(index.toString()),
                                      child: ListTile(
                                        onTap: () {},
                                        title: Text(
                                            "${index + 1}-${snapshot.data?.docs[index]['name'].toString().toUpperCase()}"),
                                      ),
                                      endActionPane: ActionPane(
                                        dismissible: DismissiblePane(
                                          onDismissed: () {
                                            debugPrint(
                                                "id :${snapshot.data!.docs[index].id}");
                                            userCon.removeMemberes(
                                              docId:
                                                  snapshot.data!.docs[index].id,
                                            );
                                          },
                                        ),
                                        motion: BehindMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              userCon.removeMemberes(
                                                docId: snapshot
                                                    .data!.docs[index].id,
                                              );
                                            },
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            label: "Delete",
                                          )
                                        ],
                                      ),
                                    ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ProfileUser extends StatelessWidget {
  const ProfileUser({
    super.key,
    required this.userInfor,
  });

  final UserModel userInfor;

  @override
  Widget build(BuildContext context) {
    final space = const SizedBox(height: 20);
    final imageCon = Get.put(ImagePickerProvider());
    final dynamicLinkCon = Get.put(DynamicLink());

    final size = 110.0;
    final notification = "1";

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: cupertinoModal,
                  );
                },
                child: imageCon.loadingUpdageImage.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.white,
                        child: Container(
                          height: size,
                          width: size,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).cardColor,
                          ),
                          image: imageCon.imageUrl.value.isEmpty
                              ? null
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    imageCon.imageUrl.value,
                                  ),
                                ),
                        ),
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: imageCon.imageUrl.value.isEmpty,
                          child: Text(
                            "${userInfor.name}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Theme.of(context).cardColor),
                          ),
                        )),
              ),
              SwitchMode(),
              Button(
                text: "Url",
                onPressed: () {
                  router.push("/urlscreen");
                },
              ),
            ],
          ),

          space,
          //     notificationsIcon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UserName: ${userInfor.name}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              badges.Badge(
                showBadge: true,
                ignorePointer: false,
                position: BadgePosition.topEnd(
                  top: -5,
                  end: -3,
                ),
                onTap: () async {
                  debugPrint("tap on badge");
                  NotificationHandler.showNotification(
                    title: "NeaYt",
                    body: "Nea has uploaded a new video come check now",
                  );
                },
                badgeContent: Text(
                  notification,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: notification.length >= 2 ? 9 : 10,
                  ),
                ),
                badgeAnimation: badges.BadgeAnimation.scale(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(notification.length >= 2 ? 5.5 : 6),
                  borderRadius: BorderRadius.circular(4),
                  // borderSide: BorderSide(color: Colors.white, width: 2),
                  elevation: 0,
                ),
                child: Icon(
                  CupertinoIcons.bell,
                  size: 28,
                ),
              ),
            ],
          ),
          space,
          Text(
            "Email: ${userInfor.email}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          space,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onLongPress: () {
                    Share.share(dynamicLinkCon.linkPath.value);
                  },
                  child: Text(
                    "Link: ${dynamicLinkCon.linkPath.value}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.amber.shade200,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () async {
                  String _link = '';
                  final String location = GoRouterState.of(context).location;
                  dynamicLinkCon.switchLink.value !=
                      dynamicLinkCon.switchLink.value;
                  _link = await dynamicLinkCon.createDynamicLink(
                    short: dynamicLinkCon.switchLink.value,
                    link: location,
                  );

                  Clipboard.setData(
                    ClipboardData(text: _link),
                  );

                  SnackBar snackBar = SnackBar(content: Text("Link Copied"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: Icon(Icons.share),
              ),
            ],
          ),
          Divider(
            height: 25,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget cupertinoModal(BuildContext context) {
    final imageCon = Get.put(ImagePickerProvider());
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ViewPhotoDetail(
                  imageUrl: imageCon.imageUrl.value.isEmpty
                      ? "https://almunajemfoods.com/wp-content/uploads/2019/07/NO_IMG_600x600.png"
                      : imageCon.imageUrl.value,
                );
              },
            ));
          },
          child: const Text('View Photo'),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            await getIt<ImagePickerProvider>()
                .pickImage(source: ImageSource.gallery);
          },
          child: imageCon.imageUrl.value.isEmpty
              ? Text("Upload Photo")
              : const Text('Change Photo'),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            await getIt<ImagePickerProvider>()
                .pickImage(source: ImageSource.camera);
          },
          child: const Text('Selfie'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            getIt<ImagePickerProvider>().removePhoto();

            Navigator.pop(context);
          },
          child: const Text('Remove'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    );
  }
}
