import 'package:dynamic_center/Screens/signup/state_mgt/sign_up_state.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:get/get.dart';

class SignUpLogic extends GetxController {
  final SignUpState state = SignUpState();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
}
