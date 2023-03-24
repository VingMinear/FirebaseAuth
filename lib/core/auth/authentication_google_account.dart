import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/core/auth/authentication.dart';

import '../../firebase_options.dart';
import '../controller/login_controller.dart';

class GoogleSignInProvider {
  final googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
  );
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user {
    return _user!;
  }

  // signInWithGoogle() async {
  //   // begin interactive sign in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  // }

  Future<void> googleLogin() async {
    // maybe bc of platofrm fix tmr;`~
    // final googleUser = await GoogleSignIn(
    //         clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
    //     .signIn();
    final loginCon = Get.put(LoginController());
    loginCon.loading(true);
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      loginCon.loading(false);
      return;
    } else {
      _user = googleUser;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final login =
        await Authentication().signInWithCredential(credential: credential);
    loginCon.loginSuccess(login);
  }
}
