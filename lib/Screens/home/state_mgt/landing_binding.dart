import 'package:dynamic_center/Screens/home/state_mgt/landing_logic.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LandingLogic());
  }
}
