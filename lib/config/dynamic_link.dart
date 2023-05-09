import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_app/config/route.dart';

class DynamicLink extends GetxController {
  FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;
  var linkPath = "".obs;
  var switchLink = false.obs;
  Future<void> initDynmicLink() async {
    _dynamicLinks.onLink.listen(
      (dynamicLink) {
        final Uri uri = dynamicLink.link;
        final queryParams = uri.queryParameters;
        debugPrint("param query$queryParams");
        router.push('${dynamicLink.link.path}');
        debugPrint("link:--<?${dynamicLink.link.path}");
      },
    ).onError((error) {
      debugPrint("error::$error");
    });
  }

  Future<String> createDynamicLink(
      {required bool short, required String link, String? refCode}) async {
    final url = "https://com.example.my_app?ref=$refCode";
    // DynamicLinkParameters parameters = DynamicLinkParameters(
    //   link: Uri.parse(uriPrefix + link),
    //   uriPrefix: uriPrefix,
    //   androidParameters: AndroidParameters(
    //     packageName: "com.example.my_app",
    //     minimumVersion: 0,
    //   ),
    // );
    DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(
        packageName: "com.example.my_app",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.example.myApp",
        minimumVersion: "0",
      ),
      link: Uri.parse(url),
      uriPrefix: "https://myprivateapp.page.link",
    );
    Uri uri;
    if (short) {
      final ShortDynamicLink shortLink =
          await _dynamicLinks.buildShortLink(parameters);
      uri = shortLink.shortUrl;
    } else {
      uri = await _dynamicLinks.buildLink(parameters);
    }
    linkPath.value = uri.toString();
    return linkPath.toString();
  }
}
