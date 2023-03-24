import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_color.dart';
import 'package:my_app/utils/helper/local_storage.dart';

class ThemeService {
  static final lightMode = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    cardColor: AppColor.darkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.darkColor,
    ),
    dividerColor: Colors.black12,
  );
  static final darkMode = ThemeData.dark().copyWith(
    primaryColor: AppColor.darkColor,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    ),
    dividerColor: Colors.white,
  );
  storeThemeData({required bool value}) async {
    await LocalStorage().storeData(key: "theme_data", value: value);
  }

  Future<bool> getMode() async {
    return await LocalStorage().getBoolData(key: "theme_data");
  }

  ThemeMode themeMode({bool? mode}) {
    return mode ?? false ? ThemeMode.dark : ThemeMode.light;
  }

  switchMode(bool mode) {
    Get.changeThemeMode(themeMode(mode: mode));
    storeThemeData(value: mode);
  }
}
