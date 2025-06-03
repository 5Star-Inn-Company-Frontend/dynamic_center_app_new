import 'package:dynamic_center/Screens/home/landing_page.dart';
import 'package:dynamic_center/Screens/home/state_mgt/landing_binding.dart';
import 'package:dynamic_center/Screens/login/login.dart';
import 'package:dynamic_center/Screens/login/state_mgt/login_binding.dart';
import 'package:dynamic_center/Screens/signup/signup.dart';
import 'package:dynamic_center/Screens/signup/state_mgt/sign_up_binding.dart';
import 'package:dynamic_center/Screens/splash/splash_screen.dart';
import 'package:dynamic_center/Screens/splash/state_mgt/splash_binding.dart';
import 'package:get/get.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SIGNUPVIEW,
      page: () => const Signup(),
      binding: SignUpBinding(),
    ),
    GetPage(name: Routes.LOGINVIEW, page: () => const Login(), binding: LoginBinding()),
    GetPage(
      name: Routes.SPLASHSCREEN,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(name: Routes.LANDINGPAGE, page: () => LandingPage(), binding: LandingBinding())
  ];
}
