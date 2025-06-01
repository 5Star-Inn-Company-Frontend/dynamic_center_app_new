import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // Initially password is obscure
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  String dialogtitle = "Login Error";
  late SharedPreferences prefs;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
    });
    // Firebase.initializeApp();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login(String email, password) async {
    // If the form is valid, display a snackbar. In the real world,
    // you'd often call a server or save the information in a database.

    print("$email is $password $device1");
    loading();
    // if(token != null){
    //   headers.addAll({"Authorization" : "Bearer "+token});
    // }
    try {
      var jsonBody = {
        'username': email,
        'password': password,
        'device_name': device1
      };
      http.Response response =
          await http.post(parseUrl("login"), body: jsonBody);

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        String data = response.body;
        var cmddetails = jsonDecode(data);
        print(cmddetails);
        if (cmddetails['status'] == 1) {
          prefs = await SharedPreferences.getInstance();
          prefs.setString('logindetails', email);
          prefs.setString('loginpass', password);
          SaveDetails(cmddetails, true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LandingPage();
              },
            ),
          );
          // Scaffold
          //     .of(context)
          //     .showSnackBar(SnackBar(content: Text('You can now login')));
        } else {
          print(cmddetails);
          print(response.statusCode);
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message'] + "\n" + cmddetails['error'],
              // onPostivePressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         // return JsonApiDropdown();
              //         return Login();
              //       },
              //     ),
              //   );
              // },
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue');
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        }
      } else {
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: "Connection Error",
            // onPostivePressed: () {},
            // positiveBtnText: 'Continue',
            negativeBtnText: 'Continue');
      }
    } catch (Exception) {
      Navigator.of(context).pop();
      print(Exception);
      var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: nonetwork,
          // onPostivePressed: () {},
          // positiveBtnText: 'Ok',
          negativeBtnText: 'Cancel');
      showDialog(context: context, builder: (BuildContext context) => dialog);
    }
    // Scaffold
    //     .of(context)
    //     .showSnackBar(SnackBar(content: Text('Processing Data')));
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      // Snackbar.showMessage('error biome trics $e');
    }
    if (canCheckBiometrics) {
      late List<BiometricType> availableBiometrics;
      try {
        availableBiometrics = await auth.getAvailableBiometrics();
      } catch (e) {}

      if (availableBiometrics.isNotEmpty) {
        for (var ab in availableBiometrics) {}
      } else {}

      bool authenticated = false;
      try {
        authenticated = await auth.authenticate(
          localizedReason: 'Place your finger on the sensor to login',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } catch (e) {}
      // setState(() {
      //   isAuth = authenticated ? true : false;
      // });
      if (authenticated) {
        _login(logindetails, loginpass);
      }
    }
  }

  // bool _isLoggedIn = false;
  late Map userProfile;

  //Example code of how to sign in with Google. this working fine without firebase
  void googlelogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount? acc) async {
      GoogleSignInAuthentication auth = await acc!.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      await prefs.setBool('googlelogin', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LandingPage();
          },
        ),
      );
      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);
      });
    });
  }

  // final plugin = FacebookLogin(debug: true);
  // Future<void> _facebooklogin() async {
  //   await plugin.logIn(permissions: [
  //     FacebookPermission.publicProfile,
  //     FacebookPermission.email,
  //   ]);
  //   await _updateLoginInfo();
  // }

  // Future<void> _onPressedLogOutButton() async {
  //   await plugin.logOut();
  //   await _updateLoginInfo();
  // }

  // Future<void> _updateLoginInfo() async {
  //   final token = await plugin.accessToken;
  //   FacebookUserProfile? profile;
  //   String? email;
  //   String? imageUrl;
  //   String? name;
  //   if (token != null) {
  //     profile = await plugin.getUserProfile();
  //     if (token.permissions.contains(FacebookPermission.email.name)) {
  //       email = await plugin.getUserEmail();
  //     }
  //     imageUrl = await plugin.getProfileImageUrl(width: 100);
  //     // _sociallogin(profile!.name, token.token, imageUrl, email, context);
  //     await prefs.setBool('facebooklogin', true);
  //     setState(() {
  //       // userProfile = profile!;
  //       _isLoggedIn = true;
  //     });
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return LandingPage();
  //         },
  //       ),
  //     );
  //   }
  // }

  //Example code of how to sign in with Google. this working fine with firebase
  void _signInWithGoogle() async {
    // try {
    //   UserCredential userCredential;
    //
    //   if (kIsWeb) {
    //     GoogleAuthProvider googleProvider = GoogleAuthProvider();
    //     userCredential = await _auth.signInWithPopup(googleProvider);
    //   } else {
    //     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    //     final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    //     final GoogleAuthCredential googleAuthCredential =
    //     GoogleAuthProvider.credential(
    //       accessToken: googleAuth.accessToken,
    //       idToken: googleAuth.idToken,
    //     );
    //     userCredential = await _auth.signInWithCredential(googleAuthCredential);
    //   }
    //
    //   final user = userCredential.user;
    //   print(user);
    //   print("Sign In ${user.uid} with Google");
    //
    //   await prefs.setBool('googlelogin', true);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return LandingPage();
    //       },
    //     ),
    //   );
    //   // Scaffold.of(context).showSnackBar(SnackBar(
    //   //   content: Text("Sign In ${user.uid} with Google"),
    //   // ));
    // } catch (e) {
    //   print("this is error");
    //   print(e);
    //
    //   // Scaffold.of(context).showSnackBar(SnackBar(
    //   //   content: Text("Failed to sign in with Google: ${e}"),
    //   // ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SizedBox(
          height: cardheight(context: context, needed: true),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Gap(50.h),
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26),
                ),

                Gap(20.h),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Image(
                    image: AssetImage("assets/images/login.png"),
                  ),
                ),

                Expanded(
                  child: Cardlayout(
                    child: Container(
                      width: size.width,
                      margin: EdgeInsets.only(top: 30.h, right: 16.w, left: 16.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            email(),
                            Gap(15.h),

                            password(),
                            Gap(10.h),
                            
                            // forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          // return JsonApiDropdown();
                                          return Forgetpassword();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: GoogleFonts.poppins(
                                        color: Color(primarycolour),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Gap(30.h),

                            // login button
                            RoundedButton(
                              text: "Login",
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  // _login(emailController.text,
                                  //     passwordController.text);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LandingPage();
                                      },
                                    ),
                                  );
                                }

                              },
                            ),
                            Gap(20.h),

                            Text(
                              "Connect With:",
                              style: GoogleFonts.poppins(color: Colors.red),
                              textAlign: TextAlign.right,
                            ),
                            Gap(8.h),

                            loginoption(size),
                            Gap(20.h),

                            // already have an account
                            AlreadyHaveAnAccountCheck(
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      // return JsonApiDropdown();
                                      return Signup();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget email() {
    return RoundedInputField(
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Email Address",
      onChanged: (value) {
        emailController.text = value;
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.contains('@')) {
          if (!EmailValidator.validate(value.toString())) {
            return "Invalid Email Address";
          }}
        // } else {
        //   if (value.length < 11) {
        //     return "Incomplete Phone number";
        //   } else if (value.length > 11) {
        //     return "Invalid Phone number";
        //     // } else if(!isValidPhoneNumber(value.toString())){
        //     //   return "Invalid Phone number";
        //   }
        // }
        return null;
      },
    );
  }

  Widget password() {
    return RoundedPasswordField(
      onChanged: (value) {
        passwordController.text = value;
      },
      press: () {
        _toggle();
      },
      obscureText: _obscureText,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }

  Widget loginoption(size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginoptionButton(
          images: "assets/images/FaceButton.png",
          press: () {
            if (!kReleaseMode) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LandingPage();
                  },
                ),
              );
            }
          },
        ),
        Gap(20.w),
        LoginoptionButton(
          images: "assets/images/BioButton.png",
          press: () {
            _checkBiometric();
          },
        ),
        Gap(20.w),
        LoginoptionButton(
          images: "assets/images/Google+.png",
          press: () {
            _signInWithGoogle();
          },
        ),
        Gap(20.w),
        // LoginoptionButton(
        //   images: "assets/images/Facebook.png",
        //   press: () {
        //     _facebooklogin();
        //   },
        // ),
      ],
    );
  }
}
