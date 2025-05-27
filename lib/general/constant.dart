import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

//  Color(primarycolour) = Color(0xff347AF0);
const int primarycolour1 = 0xff347AF0;
const primarycolour2 = Color(0xff347AF0);
int primarycolour = 0xff347AF0;
int scafoldcolour = 0xffEDF1F9;
int kTextColor = 0xFF757575;

// int kShrinePink50 = 0xFFFEEAE6;
// int kShrinePink100 = 0xFFFEDBD0;
int kShrineFrameBrown = 0x8A442C2E;
int kShrineScrim = 0x73442C2E;
// const Color kShrinePink50 = Color(0xFFFEEAE6);
// const Color kShrinePink100 = Color(0xFFFEDBD0);
// const Color kShrineFrameBrown = Color(0x8A442C2E);
// const Color kShrineScrim = Color(0x73442C2E);

String Baseurl = "https://dynamiccenter.5starcompany.com.ng/api/";
String nonetwork = "No internet connection, try again later";
String versionsecurityPatch = "";
int versionsdkInt = 0;
String versionrelease = "";
int versionpreviewSdkInt = 0;
String versionincremental = "";
String versioncodename = "";
String versionbaseOS = "";
String board = "";
String bootloader = "";
int hashCode = 0;
String brand = "";
String device = "";
String display = "";
String fingerprint = "";
String hardware = "";
String host = "";
String id = "23";
String manufacturer = "";
String model = "";
String product = "";
List<String> supported32BitAbis = [];
List<String> supported64BitAbis = [];
List<String> supportedAbis = [];
String tags = "";
String type = "";
bool isPhysicalDevice = false;
String androidId = "";
List<String> systemFeatures = [];
String name = "";
String systemName = "";
String systemVersion = "";
String localizedModel = "";
String identifierForVendor = "";
String utsnamesysname = "";
String utsnamenodename = "";
String utsnamerelease = "";
String utsnameversion = "";
String utsnamemachine = "";
bool draweropen = false;
String appversion = "1";
String profile_path =
    "https://ui-avatars.com/api/?name=Sa&color=7F9CF5&background=EBF4FF";
String first_name = "samji";
String last_name = "samji";
String company = "Samji";
int wallet = 0;
String token = "";
String gender = "";
String address = "";
String dob = "";
String country = "";
String referral = "";
String email = "";
String phoneno = "";
int point = 0;
int level = 0;
String account = "";
String bonus = "";
String logindetails = "";
String loginpass = "";
String versionapp = "";
String device1 = "";
String appName = "";
String packageName = "";
String buildNumber = "";
String localauth = "";
bool intro = false;
bool googlelogin = false;
bool facebooklogin = false;
String paystack_pub_test = "pk_test_b987677881ebe03cc259505b4dbd30da70651f64";
String paystackPublicKey = paystack_pub_test;
parseUrl(endpoint) {
  // return Uri.parse("${decrypt(Baseurl)}" + endpoint);
  return Uri.parse("${Baseurl}" + endpoint);
}

bool isValidPhoneNumber(String phoneNumber) {
  // You may need to change this pattern to fit your requirement.
  // I just copied the pattern from here: https://regexr.com/3c53v
  final pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  final regExp = RegExp(pattern);

  if (phoneNumber == null || phoneNumber.isEmpty) {
    return false;
  }

  if (!regExp.hasMatch(phoneNumber)) {
    return false;
  }
  return true;
}

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 30),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Color(kTextColor)),
  );
}
