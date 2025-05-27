import 'dart:io';
import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/Screens/paybill.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/confirm_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:dynamic_center/general/constant.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';


class Xchange extends StatefulWidget {
  Xchange({Key? key}) : super(key: key);

  @override
  _XchangeState createState() => _XchangeState();
}

class _XchangeState extends State<Xchange> {
  String _selectedLocation = "", percent="0", code = "", type = "Buy";
  List<Source> _region = [];
  late Source _currentUser;
  String dialogtitle = "Error in Xchange";
  var cmddetails;
  bool isSwitched = false;
  final GlobalKey<FormState> _Buykey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    _mockCheckForSession().then(
            (status) async{
          if (status) {
            loading();
          }
        }
    );
  }
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 100), () {});

    return true;
  }
  void getData() async {
    try {
      // loading();
      http.Response response = await http.get(parseUrl("electricityconfig"),
          headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        // var data1 = cmddetails["data"];
        print(cmddetails);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        setState(() {
          _region = items.map<Source>((json) {
            return Source.fromJson(json);
          }).toList();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        Snackbar.showMessage("Contact Admin", _scaffoldKey);

        var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: "Contact Admin",
          onPostivePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LandingPage();
                },
              ),
            );
          },
          positiveBtnText: 'Continue',
          // negativeBtnText: 'No'
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
        // onPostivePressed: () {
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       // return JsonApiDropdown();
        //       return Login();
        //     },
        //   ),
        // );
        // },
        // positiveBtnText: 'Yes',
        negativeBtnText: 'Ok'
      );
      showDialog(
          context: context,
          builder: (BuildContext context) => dialog);
    }
  }
  void loading(){
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
  void _Xchange() async {
    if (_Buykey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'number': phoneController.text,
          'code': code,
          'version': appversion,
          'amount': amountController.text,
        };
        http.Response response = await http.post(
            parseUrl("buy/electricity"), body: json_body);

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
              message: cmddetails['message'],
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
              negativeBtnText: 'Continue'
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
  void _verifyelectricity() async {
    if (_Buykey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'number': phoneController.text,
          'type': "prepaid",
          'provider': _currentUser.name,
        };
        http.Response response = await http.post(
            parseUrl("buy/electricity"), body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if(cmddetails['status'] == 1){
            var dialog = ConfirmDialog(
                title: "success",
                topic: "Verified Successfully!!",
                subtopic: cmddetails['message'],
                onPostivePressed: () {
                  _Xchange();
                },
                positiveBtnText: 'Subscribe 😀',
                negativeBtnText: 'Cancel 🥺'
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => dialog);
          }else{
            var dialog = ConfirmDialog(
                title: "failed",
                topic: cmddetails['message'],
                message: 0xffDF5060,
                onPostivePressed: () {
                  Navigator.of(context).pop();
                  _verifyelectricity();
                },
                positiveBtnText: 'Retry 🥺',
                // negativeBtnText: 'Retry 🥺'
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
        print(Exception);
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
    return
    MainActivity(
      scaffoldKey: _scaffoldKey,
        child: Paybill(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Text("Xchange",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.left,
                ),
                Container(height: 20,),

                Form(
                  key: _Buykey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Coin"),
                        Networklist(),
                        Container(height: 20,),
                        Row(
                          children: [
                            Text(type),
                            Spacer(),
                            Switch(
                              value: isSwitched,
                              onChanged: (value){
                                setState(() {
                                  isSwitched=value;
                                  if(value){
                                    type = "Sell";
                                  } else{
                                    type = "Buy";
                                  }
                                  // print(isSwitched);
                                });
                              },
                              activeTrackColor: Color(primarycolour),
                              activeColor: Colors.green,
                            ),
                        ],
                        ),
                        Container(height: 20,),
                        Text("Amount"),
                        amount(),
                        Container(height: 20,),
                        Text("Wallet Address"),
                        phoneno (),
                      ]
                  ),
                ),
                Container(height: 20,),
                RoundedButton(
                  text: "Submit Now",
                  press: () {
                    _verifyelectricity();
                  },
                ),
              ],
            ),
          ),
       )
    );
  }
  Widget Networklist(){
    return
      DropdownButtonFormField<Source>(
        items:  _region.map((user) {
          return DropdownMenuItem<Source>(
            child: Text(user.name),
            value:  user,
          );}
        ).toList(),
        value:  _currentUser,
        hint: Text('e.g. Bitcoin '),
        onChanged: (Source? salutation) =>
            setState(() {
              _currentUser = salutation!;
              code =_currentUser.identifier.toString();
            }),
        validator: (value) => value == null ? 'field required' : null,
      );
  }

  Widget amount() {
    return RoundedInputField(
      hintText: "e.g 500",
      onChanged: (value) {
        setState(() {
          amountController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }

  Widget phoneno () {
    return RoundedInputField(
      hintText: "e.g. 67834ur3udfikjwdsf9fewiofkd",
      onChanged: (value) {
        setState(() {
          phoneController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 11) {
          return "incomplete phone number";
        }else if (value.length > 11) {
          return "invalid phone number";
        }
        return null;
      },
    );
  }
}


class Source {
  int id;
  String name;
  String identifier;

  Source({required this.id, required this.name, required this.identifier});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["price"] as int,
      name: json["code"] as String,
      identifier: json["identifier"] as String,
    );
  }
}