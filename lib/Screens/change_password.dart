import 'dart:convert';
import 'package:dynamic_center/Screens/home/landing_page.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_password_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'dart:io';


class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController(); // Option 2
  TextEditingController newpasswordController = TextEditingController(); // Option 2
  TextEditingController repeatpasswordController = TextEditingController(); // Option 2
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String dialogtitle = "Updating profile Error";
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool confirm = false;
  bool matching = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }
  void loading(){
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
  void _login() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      if(newpasswordController.text != repeatpasswordController.text){
        setState(() {
          confirm = true;
        });
        return;
      }
      setState(() {
        confirm = false;
      });
      // loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'oldpassword': passwordController.text,
          'newpassword': newpasswordController.text,
        };
        http.Response response = await http.post(
            parseUrl("changepassword"), body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if(cmddetails['status'] == 1){
            Navigator.push(
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
          }else{
            var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message']+"\n"+cmddetails['error'],
              onPostivePressed: () {
                // Navigator.push(
                //   context,
                // MaterialPageRoute(
                //   builder: (context) {
                //     // return JsonApiDropdown();
                //     return Login();
                //   },
                // ),
                // );
              },
              positiveBtnText: 'Continue',
              // negativeBtnText: 'Cancel'
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => dialog);
          }
        } else {
          Navigator.of(context).pop();
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: "Connection Error",
              // onPostivePressed: () {},
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue'
          );
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog);
        }
      }catch(Exception){
        print(Exception);
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: nonetwork,
            // onPostivePressed: () {},
            // positiveBtnText: 'Ok',
            negativeBtnText: 'Cancel');
        showDialog(
            context: context,
            builder: (BuildContext context) => dialog);
      }
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 50,),
          child: Cardlayout(
            child: Form(
              key: _formKey,
              child: Container(
                width: size.width,
                height: size.height,
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 20,),
                      password(),
                      SizedBox(height: 30,),
                      newpassword(),
                      SizedBox(height: 30,),
                      repeatpassword(),
                      Container(
                        width: size.width,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child:Visibility(
                          visible: confirm, //Default is true,
                          child:
                          Text("Password not match",
                            style: GoogleFonts.poppins(color: Colors.red),
                            textAlign: TextAlign.start,
                          )

                        ),
                      ),
                      Container(height: 90,),
                      RoundedButton(
                        text: "Change Password",
                        press: () {
                          _login();
                        },
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget password (){
    return RoundedPasswordField(
      onChanged: (value) {

      },
      label: "Current password",
      press: () {_toggle();},
      obscureText: _obscureText,
      controller: passwordController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }
  Widget newpassword (){
    return RoundedPasswordField(
      onChanged: (value) {
        },
      label: "New Password",
      controller: newpasswordController,
      press: () {_toggle1();},
      obscureText: _obscureText1,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }
  Widget repeatpassword (){
    return RoundedPasswordField(
      onChanged: (value) {

      },
      label: "Repeat password",
      controller: repeatpasswordController,
      press: () {_toggle2();},
      obscureText: _obscureText2,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }
}