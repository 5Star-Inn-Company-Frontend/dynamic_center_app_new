import 'package:get/get.dart';

class SignUpState {
  SignUpState();
  List<String> option = ['Email', 'Phone number'];
  RxInt selectedIndex = 0.obs;
  RxBool groupValue = false.obs;

  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;

  RxBool isMale = false.obs;
  RxBool isFemale = false.obs;

  RxBool isLoading = false.obs;
}
