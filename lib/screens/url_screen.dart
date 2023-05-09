import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/components/button.dart';
import 'package:my_app/components/button_nobg.dart';
import 'package:my_app/components/text_field_custom.dart';
import 'package:my_app/controller/url_screen_crontroller.dart';

import '../config/route.dart';

class UrlScreen extends StatelessWidget {
  const UrlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.put(UrlController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: const FadeInImage(
                image: NetworkImage(
                    "https://i0.wp.com/zeevector.com/wp-content/uploads/Background/Cloud-background-HD.jpg?fit=1288%2C1521&ssl=1"),
                placeholder: AssetImage("assets/flutter_logo.png"),
              ).image,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.2),
              MyTextField(
                inputController: con.textCon.value,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonNoBackground(
                    text: "Clear",
                    onPressed: () {
                      con.textCon.value.text = "";
                    },
                  ),
                  Button(
                    text: "Next",
                    onPressed: () {
                      if (con.textCon.value.text.isNotEmpty) {
                        router.push("/webview");

                        con.loadingWebView(true);
                      } else {
                        debugPrint("empty");
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Button(
                text: "Add Https:// & .com",
                onPressed: () {
                  con.textCon.value.text =
                      "https://${con.textCon.value.text}.com";
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
