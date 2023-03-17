import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/url_screen_crontroller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;
  var con = Get.put(UrlController());
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Started loading');
          },
          onPageStarted: (String url) {
            con.loadingWebView(true);
            debugPrint('on starting');
          },
          onPageFinished: (String url) {
            con.loadingWebView(false);
            debugPrint('Finish loading');
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(con.textCon.value.text),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => con.loadingWebView.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
      ),
    );
  }
}
