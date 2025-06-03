import 'package:get/get.dart';

class LoginState {
  LoginState();
  List<String> option = ['Email', 'Phone number', 'Username'];
  RxInt selectedIndex = 0.obs;
  RxBool groupValue = false.obs;

  List<String> images = [
    'images/Gamil.png',
    'images/Vector.png',
    'images/Facebook.png'
  ];

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
}
