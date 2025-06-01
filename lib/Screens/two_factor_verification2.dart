import 'dart:async';
import 'dart:typed_data';

import 'package:dynamic_center/general/size_config.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';

class TwoFactorVerification2 extends StatefulWidget {
  TwoFactorVerification2({Key? key}) : super(key: key);

  @override
  _TwoFactorVerification2State createState() => _TwoFactorVerification2State();
}

class _TwoFactorVerification2State extends State<TwoFactorVerification2> {
  Uint8List bytes = Uint8List(0);
  String quote = "3M8w2knJKsr3jqMatYiyuraxVvZAmuZy24lK8";
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  static Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data!.text.toString();
  }

  void paste8() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    print("i don paste oooooo");
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text(
          "Two-Factor Verification",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: cardheight(context: context),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Please enter the confirmation code from your auth app",
                    style: GoogleFonts.poppins(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: size.height / 1.9),
                Expanded(
                  child: Cardlayout(
                    child: Container(
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(children: [
                        SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: phoneno(),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            paste().then((value) {
                              setState(() {
                                codeController.text = value;
                              });
                            });
                          },
                          child: Text(
                            'Paste Code',
                            style: GoogleFonts.poppins(
                                color: Color(primarycolour),
                                fontWeight: FontWeight.bold,
                                fontSize: 19),
                          ),
                        ),
                        SizedBox(height: 50),
                        RoundedButton(
                          text: "Done",
                          press: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           VerifyPhoneNumber3(phonenumber: code + phoneController.text,),
                            //     ));
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Confirmation code",
      onChanged: (value) {
        setState(() {
          codeController.text = value;
        });
      },
      controller: codeController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }
}
