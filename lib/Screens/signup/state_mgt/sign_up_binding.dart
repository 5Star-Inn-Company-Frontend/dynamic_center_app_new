import 'package:dynamic_center/Screens/signup/state_mgt/sign_up_logic.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpLogic());
  }
}
