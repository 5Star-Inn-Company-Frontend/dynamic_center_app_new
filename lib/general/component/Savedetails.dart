import 'package:dynamic_center/general/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

SaveDetails(cmddetails, login) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (login) {
    first_name = cmddetails['first_name'];
    prefs.setString('first_name', cmddetails['first_name']);
    last_name = cmddetails['last_name'];
    prefs.setString('last_name', cmddetails['last_name']);
    company = cmddetails['company'];
    prefs.setString('company', cmddetails['company']);
    profile_path = cmddetails['profile_path'];
    prefs.setString('profile_path', cmddetails['profile_path']);
    token = cmddetails['token'];
    prefs.setString('token', cmddetails['token']);
    return;
  }
  first_name = cmddetails['first_name'];
  prefs.setString('first_name', cmddetails['first_name']);
  last_name = cmddetails['last_name'];
  prefs.setString('last_name', cmddetails['last_name']);
  // company = cmddetails['company'];
  // prefs.setString('company', cmddetails['company']);
  // profile_path = cmddetails[' profile_photo_url'];
  // prefs.setString('profile_path', cmddetails[' profile_photo_url']);
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
  first_name = prefs.getString('first_name') ?? "";
  last_name = prefs.getString('last_name') ?? "";
  company = prefs.getString('company') ?? "";
  profile_path = prefs.getString('profile_path') ?? "";
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
