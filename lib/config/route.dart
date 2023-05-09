import 'package:go_router/go_router.dart';
import 'package:my_app/core/screen/forgot_pass.dart';
import 'package:my_app/core/screen/login.dart';
import 'package:my_app/core/screen/splash_screen.dart';
import 'package:my_app/screens/add_user.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/url_screen.dart';
import 'package:my_app/screens/web_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/forgotpassword',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: '/adduser',
      builder: (context, state) => AddUser(),
    ),
    GoRoute(
      path: '/webview',
      builder: (context, state) => WebView(),
    ),
    GoRoute(
      path: '/urlscreen',
      builder: (context, state) => UrlScreen(),
    ),
  ],
);
