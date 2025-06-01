import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/services.dart';

// class Deviceinfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
// Map<String, dynamic> _deviceData = <String, dynamic>{};

Future<void> initPlatformState() async {
  Map<String, dynamic> deviceData;
  try {
    if (Platform.isAndroid) {
      // deviceData =
      _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      // AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      //
      // androidId= androidInfo.androidId;
      // board = androidInfo.board;
      // bootloader= androidInfo.bootloader;
      // brand= androidInfo.brand;
      // device= androidInfo.device;
      // display= androidInfo.display;
      // fingerprint= androidInfo.fingerprint;
      // hardware= androidInfo.hardware;
      // host =androidInfo.host;
      // id= androidInfo.id;
      // isPhysicalDevice = androidInfo.isPhysicalDevice;
      // manufacturer= androidInfo.manufacturer;
      // model=androidInfo.model;
      // product= androidInfo.product;
    } else if (Platform.isIOS) {
      // deviceData =
      _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
  // print(deviceData);
  //   return deviceData;

  // if (!mounted) return;
  //
  // setState(() {
  //   _deviceData = deviceData;
  // });
}

_readAndroidBuildData(AndroidDeviceInfo build) {
  versionsecurityPatch = build.version.securityPatch!;
  versionsdkInt = build.version.sdkInt;
  versionrelease = build.version.release;
  versionpreviewSdkInt = build.version.previewSdkInt!;
  versionincremental = build.version.incremental;
  versioncodename = build.version.codename;
  versionbaseOS = build.version.baseOS!;
  board = build.board;
  bootloader = build.bootloader;
  brand = build.brand;
  device = build.device;
  display = build.display;
  fingerprint = build.fingerprint;
  hardware = build.hardware;
  hashCode = build.hashCode;
  host = build.host;
  id = build.id;
  manufacturer = build.manufacturer;
  model = build.model;
  product = build.product;
  supported32BitAbis = build.supported32BitAbis;
  supported64BitAbis = build.supported64BitAbis;
  supportedAbis = build.supportedAbis;
  tags = build.tags;
  type = build.type;
  isPhysicalDevice = build.isPhysicalDevice;
  androidId = "";
  systemFeatures = build.systemFeatures;
}

_readIosDeviceInfo(IosDeviceInfo data) {
  name = data.name;
  systemName = data.systemName;
  systemVersion = data.systemVersion;
  model = data.model;
  localizedModel = data.localizedModel;
  identifierForVendor = data.identifierForVendor!;
  isPhysicalDevice = data.isPhysicalDevice;
  utsnamesysname = data.utsname.sysname;
  utsnamenodename = data.utsname.nodename;
  utsnamerelease = data.utsname.release;
  utsnameversion = data.utsname.version;
  utsnamemachine = data.utsname.machine;
}
