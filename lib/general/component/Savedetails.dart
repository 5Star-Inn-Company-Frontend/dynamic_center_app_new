import 'package:dynamic_center/general/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

SaveDetails(cmddetails, login) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (login) {
    firstName = cmddetails['firstName'];
    prefs.setString('firstName', cmddetails['firstName']);
    lastName = cmddetails['lastName'];
    prefs.setString('lastName', cmddetails['lastName']);
    company = cmddetails['company'];
    prefs.setString('company', cmddetails['company']);
    profilePath = cmddetails['profilePath'];
    prefs.setString('profilePath', cmddetails['profilePath']);
    token = cmddetails['token'];
    prefs.setString('token', cmddetails['token']);
    return;
  }
  firstName = cmddetails['firstName'];
  prefs.setString('firstName', cmddetails['firstName']);
  lastName = cmddetails['lastName'];
  prefs.setString('lastName', cmddetails['lastName']);
  // company = cmddetails['company'];
  // prefs.setString('company', cmddetails['company']);
  // profilePath = cmddetails[' profile_photo_url'];
  // prefs.setString('profilePath', cmddetails[' profile_photo_url']);
  email = cmddetails['email'];
  prefs.setString('email', cmddetails['email']);
  phoneno = cmddetails['phoneno'];
  prefs.setString('phoneno', cmddetails['phoneno']);
  gender = cmddetails['gender'];
  prefs.setString('gender', cmddetails['gender']);
  address = cmddetails['address'];
  prefs.setString('address', cmddetails['address']);
  dob = cmddetails['dob'];
  prefs.setString('dob', cmddetails['dob']);
  country = cmddetails['country'];
  prefs.setString('country', cmddetails['country']);
  referral = cmddetails['referral'];
  prefs.setString('referral', cmddetails['referral']);
  point = cmddetails['point'];
  prefs.setInt('point', cmddetails['point']);
  level = cmddetails['level'];
  prefs.setInt('level', cmddetails['level']);
  account = cmddetails['accountno'];
  prefs.setString('accountno', cmddetails['accountno']);
  bonus = cmddetails['bonus'];
  prefs.setString('bonus', cmddetails['bonus']);
  wallet = cmddetails['wallet'];
  prefs.setInt('wallet', cmddetails['wallet']);
  prefs.setString('localauth', "1");
}

getdetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstName = prefs.getString('firstName') ?? "";
  lastName = prefs.getString('lastName') ?? "";
  company = prefs.getString('company') ?? "";
  profilePath = prefs.getString('profilePath') ?? "";
  wallet = prefs.getInt('wallet') ?? 0;
  token = prefs.getString('token') ?? "";
  logindetails = prefs.getString('logindetails') ?? "";
  loginpass = prefs.getString('loginpass') ?? "";
  localauth = prefs.getString('localauth') ?? "";
  address = prefs.getString('address') ?? "";
  intro = prefs.getBool('intro') ?? false;
  googlelogin = prefs.getBool('googlelogin') ?? false;
  facebooklogin = prefs.getBool('facebooklogin') ?? false;
}
