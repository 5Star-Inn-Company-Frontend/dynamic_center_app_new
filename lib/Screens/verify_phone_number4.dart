import 'package:dynamic_center/Screens/profile.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNumber4 extends StatefulWidget {
  VerifyPhoneNumber4({
    Key? key,
  }) : super(key: key);
  @override
  _VerifyPhoneNumber4State createState() => _VerifyPhoneNumber4State();
}

class _VerifyPhoneNumber4State extends State<VerifyPhoneNumber4> {
  @override
  void initState() {
    super.initState();
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
          "Well Done!",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
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
              "Your phone number has changed successfully.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80),
            Image(
              image: AssetImage("assets/images/success.png"),
            ),
            SizedBox(height: 80),
            RoundedButton(
              text: "Back to Profile",
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Profile();
                    },
                  ),
                );
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
