import 'dart:io' show Platform;

class DeviceAllow{
  static allow(){
    if(Platform.isAndroid || Platform.isIOS) {
      return true;
    } else{
      return false;
    }
  }
}