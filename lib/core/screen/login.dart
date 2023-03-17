import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import 'package:my_app/components/button.dart';
import 'package:my_app/components/google_btn.dart';
import 'package:my_app/components/text_field_custom.dart';
import 'package:my_app/core/controller/login_controller.dart';
import 'package:my_app/utils/helper/local_storage.dart';
import 'package:validators/validators.dart';

import '../../screens/url_screen.dart';
import '../auth/auth.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final User? user = Authentication().currentUser;
  final GlobalKey<FormState> frmKey = GlobalKey<FormState>();
  final loginCon = Get.put(LoginController());
  Future<void> _login(LoginData loginData) async {
    log("LoginData :$loginData");
    loginCon.loading(true);
    bool login = await Authentication().signInWithEmailAndPassword(
      email: loginData.name,
      password: loginData.password,
    );

    await loginSuccess(login);
    loginCon.loading(false);
  }

  Future<void> loginSuccess(bool login) async {
    if (login) {
      debugPrint("User : ${Authentication().currentUser}");
      var user_id = await Authentication().currentUser?.uid;
      LocalStorage().storeData(
        key: "user_id",
        value: user_id,
      );
      await Future.delayed(
        const Duration(milliseconds: 800),
        () {
          loginCon.onClear();
          Get.off(UrlScreen());
        },
      );
    } else {
      debugPrint("cannot login");
    }
  }

  Future<void> signUp(LoginData loginData) async {
    loginCon.loading(true);
    bool login = await Authentication().createUserWithEmailAndPassword(
      email: loginData.name,
      password: loginData.password,
    );
    Authentication.snackBarSuccess(
      title: "Congratulations",
      message: "Your account has been created successfully",
    );
    await loginSuccess(login);
    loginCon.loading(false);
  }

  final space = const SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => loginCon.loading.value
              ? Loading()
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: frmKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        MyTextField(
                          inputController: loginCon.txtPass,
                          hintText: "Password",
                          obscureText: true,
                          onChanged: (p0) {
                            if (p0.length >= 8) {
                              loginCon.isPassCorrect(true);
                            } else {
                              loginCon.isPassCorrect(false);
                            }
                          },
                          validator: (p0) {
                            if (p0!.isEmpty) return "Please Input Password";
                            return null;
                          },
                          icon: loginCon.isPassCorrect.value
                              ? Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                        space,
                        Button(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            var email = loginCon.txtEmail.text;
                            var pass = loginCon.txtPass.text;
                            var isEmailCorr = loginCon.isEmailCorrect.value;
                            var isPassCorr = loginCon.isPassCorrect.value;
                            Future.delayed(
                              const Duration(milliseconds: 350),
                              () {
                                if (isPassCorr && isEmailCorr) {
                                  var data =
                                      LoginData(name: email, password: pass);
                                  if (loginCon.textBtn.value.toLowerCase() ==
                                      "login") {
                                    _login(data);
                                  } else {
                                    signUp(data);
                                  }
                                } else {
                                  frmKey.currentState!.validate();
                                }
                              },
                            );
                          },
                          text: loginCon.textBtn.value,
                        ),
                        space,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loginCon.textBtn.value.toLowerCase() == "login"
                                ? Text("Don't have an Account ? ")
                                : Text(""),
                            InkWell(
                              onTap: () {
                                loginCon.onClear();
                                // frmKey.currentState!.reset();
                                if (loginCon.textBtn.value.toLowerCase() ==
                                    "login") {
                                  loginCon.textBtn("SignUp");
                                } else {
                                  loginCon.textBtn("LogIn");
                                }
                              },
                              child: Text(
                                loginCon.textBtn.value.toLowerCase() == "login"
                                    ? "Create New Account"
                                    : "Already have an Account",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ],
                        ),
                        space,
                        or(),
                        GoogleBtn(
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class or extends StatelessWidget {
  const or({
    Key? key,
  }) : super(key: key);
  final divider = const Expanded(
    child: Divider(
      thickness: 1,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        divider,
        const SizedBox(width: 5),
        Text("Or"),
        const SizedBox(width: 5),
        divider,
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
