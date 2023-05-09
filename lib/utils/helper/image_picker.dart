import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:my_app/core/auth/cloud_fire_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../core/controller/login_controller.dart';

@injectable
class ImagePickerProvider extends GetxController {
  @factoryMethod
  static init() => Get.put(ImagePickerProvider());
  static final ref = FirebaseStorage.instance.ref();
  var loadingUpdageImage = false.obs;
  var imageUrl = "".obs;
  removePhoto() async {
    var docId = LoginController.userInformation;
    imageUrl("");
    CloudFireStore().updateUser(
      docId: docId.id!,
      data: {
        "photo": imageUrl.value,
      },
    );
  }

  Future<void> deletedAllPhoto(String name) async {
    try {
      var data = await ref.child('images').list();
      data.items.map((e) {
        debugPrint("name ${e.name}\npath:${e.fullPath}");
        if (name != e.name) {
          e.delete();
        }
      }).toList();
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in deleled this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in deleled this is error : >> $error',
      );
    }
  }

  Future<void> uploadPhoto({
    required String path,
  }) async {
    loadingUpdageImage(true);
    try {
      final data = await ref
          .child('images')
          .child('${DateTime.now().toIso8601String() + p.basename(path)}');
      final result = await data.putFile(File(path));
      final fileUrl = await result.ref.getDownloadURL();
      imageUrl.value = fileUrl;
      var docId = LoginController.userInformation;
      CloudFireStore().updateUser(
        docId: docId.id!,
        data: {
          "photo": imageUrl.value,
        },
      );
      loadingUpdageImage(false);
      // deleted all photo in storage except for new photo
      await deletedAllPhoto(result.ref.name);
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in updateData this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in updateData this is error : >> $error',
      );
    }
    loadingUpdageImage(false);
  }

  final userInfor = LoginController.getUserInforAfterLogin();
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return;
      var file = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (file == null) return;
      var filePath = (await compressImage(file.path));
      uploadPhoto(path: filePath.path);
    } on PlatformException catch (error) {
      debugPrint(
        'CatchError when pickImage this is error : >> $error',
      );
    }
  }

  Future<File> compressImage(String path) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath);
    return result!;
  }
}
