import 'package:dynamic_center/Screens/verify_phone_number.dart';
import 'package:dynamic_center/Screens/verify_phone_number4.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyPhoneNumber3 extends StatefulWidget {
  String phonenumber;
  VerifyPhoneNumber3({Key? key, required this.phonenumber}) : super(key: key);
  @override
  _VerifyPhoneNumber3State createState() => _VerifyPhoneNumber3State();
}

class _VerifyPhoneNumber3State extends State<VerifyPhoneNumber3> {
  String button = "Resend Code";
  String dialogtitle = "Phone number Authentication Error";
  String _message = '';
  String _verificationId = "";
  String otp = "";
  bool _isloading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
// @override
  // void dispose() {
  //   super.dispose();
  //   flutterTts.stop();
  // }

  _authCompleted() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('phoneauth', formatted);
    // if(fraud == ""){
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return DashBoard(home: "hi",);
    //       },
    //     ),
    //   );
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return DisabledHome();
    //       },
    //     ),
    //   );
    // }
  }
  void signInWithPhoneAuthCredential(PhoneAuthCredential credential) {
    _auth.signInWithCredential(credential).whenComplete(() {});
  }

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });
    print(widget.phonenumber);
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text(
      //       "Phone number automatically verified and user signed in: ${phoneAuthCredential}"),
      // ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VerifyPhoneNumber4();
          },
        ),
      );
      print(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      if (authException.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
      var dialog = CustomAlertDialog(
        title: dialogtitle,
        message: _message,
        onPostivePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VerifyPhoneNumber();
              },
            ),
          );
        },
        positiveBtnText: 'Try Again',
        // negativeBtnText: 'Cancel'
      );
      showDialog(context: context, builder: (BuildContext context) => dialog);
      print(_message);
    };

    PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) async {
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text("Please check your phone for the verification code.")));

      print("Please check your phone for the verification code." +
          verificationId);
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.phonenumber,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      var dialog = CustomAlertDialog(
        title: dialogtitle,
        message: "Failed to Verify Phone Number: ${e}",
        onPostivePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VerifyPhoneNumber();
              },
            ),
          );
        },
        positiveBtnText: 'Try Again',
        // negativeBtnText: 'Cancel'
      );
      showDialog(context: context, builder: (BuildContext context) => dialog);
      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text("Failed to Verify Phone Number: ${e}"),
      // ));
      print("the error is");
      print(e);
    }
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

// Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    // loading();
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      setState(() {
        _isloading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VerifyPhoneNumber4();
          },
        ),
      );
    } catch (e) {
      print(e);
      var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: "Failed to sign in",
          // onPostivePressed: () {},
          // positiveBtnText: 'Ok',
          negativeBtnText: 'Cancel');
      showDialog(context: context, builder: (BuildContext context) => dialog);
      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text("Failed to sign in"),
      // ));
      print("Failed to sign in");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text(
          "Verify Number",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 20, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 40),
            Text(
              "Please enter the 4-digit number we have sent to your phone",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.only(left: screenWidth * 0.025),
              child: OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 50,
                fieldStyle: FieldStyle.box,
                style: GoogleFonts.poppins(fontSize: 17),
                onCompleted: (pin) {
                  print("Completed: " + pin);
                  setState(() {
                    otp = pin;
                    button = "Verify";
                  });
                },
                onChanged: (pin) {
                  if (pin.length != 6) {
                    setState(() {
                      button = "Resend Code";
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 80),
            RoundedButton(
              text: button,
              press: () {
                if (button == "Resend Code") {
                  _verifyPhoneNumber();
                } else {
                  _signInWithPhoneNumber();
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

//Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
