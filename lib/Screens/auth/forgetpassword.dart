import 'package:dynamic_center/Screens/auth/login.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dynamic_center/general/constant.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({Key? key}) : super(key: key);

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String dialogtitle = "Forget Password Error";
  bool _isloading = false;
  void loading(){
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
  void _resetpassword(String email) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'username': email,
        };
        http.Response response = await http.post(parseUrl('resetpassword'), body: json_body);

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if(cmddetails['status'] == 1){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  // return JsonApiDropdown();
                  return Login();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
          child: Container(
          height: size.height,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
               Row(
                 children: [
                   IconButton(icon: Icon(Icons.arrow_back_ios_sharp), onPressed: (){
                     Navigator.pop(context);
                   }),
                 SizedBox(width: 50,),
                 Text(
                   "Forgot Password?",
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                 ),
               ],),
                SizedBox(height: size.height * 0.03),
                Text(
                  "Enter your registrated email address/Phone number to receive password reset instruction",
                  style: TextStyle(fontSize: 15,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.3),
                Expanded(
                  child:
                Cardlayout(
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Email(),
                          SizedBox(height: size.height * 0.2
                          ),
                          RoundedButton(
                            text: "Reset Password",
                            press: () {
                              _resetpassword(emailController.text);},
                          ),
                          SizedBox(height: size.height * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
                ),
              ]
          ),
        ),
        ),
    );
  }
  Widget Email () {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),

      ],
      labelText: "Your Email/Phone number",
      onChanged: (value) {
        emailController.text = value;
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.contains('@')) {
          if (!EmailValidator.validate(value.toString())) {
            return "Invalid Email Address";
          }
        } else {
          if (value.length < 11) {
            return "Incomplete Phone number";
          } else if (value.length > 11) {
            return "Invalid Phone number";
          } else if(!isValidPhoneNumber(value.toString())){
            return "Invalid Phone number";
          }
        }
        return null;
      },
    );
  }
}