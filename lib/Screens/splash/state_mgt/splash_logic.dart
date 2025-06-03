import 'package:dynamic_center/Screens/splash/state_mgt/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashLogic extends GetxController {
  late SplashState state;

  SplashLogic({required AnimationController animationController}) {
    state = SplashState(animationController: animationController);
  }

  // void navigateToNextPage() {
  //   Future.delayed(const Duration(seconds: 4), () {
  //     Get.toNamed(Routes.ONBOARDING);
  //   });
  // }
}
