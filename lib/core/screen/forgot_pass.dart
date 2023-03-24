import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/components/button.dart';
import 'package:my_app/core/auth/authentication.dart';
import 'package:my_app/core/screen/login.dart';
import 'package:validators/validators.dart';

import '../../components/text_field_custom.dart';
import '../controller/login_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});
  final space = const SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    final loginCon = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Obx(
        () => loginCon.loading.value
            ? Loading()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please Input your Email to Reset Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    space,
                    MyTextField(
                      inputController: loginCon.txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        loginCon.isEmailCorrect.value = isEmail(value);
                      },
                      validator: (p0) {
                        if (p0!.isEmpty) return "Please Input Email";
                        return null;
                      },
                      hintText: "Email",
                      icon: loginCon.isEmailCorrect.value
                          ? Icon(
                              CupertinoIcons.check_mark,
                              color: Colors.green,
                            )
                          : null,
                    ),
                    space,
                    Button(
                      text: "Send Email",
                      onPressed: () async {
                        loginCon.loading(true);
                        await Authentication().resetPassword(
                          email: loginCon.txtEmail.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Check your email."),
                          ),
                        );
                        loginCon.loading(false);
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
