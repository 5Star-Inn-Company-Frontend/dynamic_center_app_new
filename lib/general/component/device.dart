import 'dart:io' show Platform, exit;

class deviceallow{
  static allow(){
    if(Platform.isAndroid || Platform.isIOS) {
      return true;
    } else{
      return false;
    }
  }
}