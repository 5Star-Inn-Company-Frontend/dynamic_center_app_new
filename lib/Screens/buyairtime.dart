import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/deposit.dart';
import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/home/landing_page.dart';
import 'package:dynamic_center/Screens/paybill.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Buyairtime extends StatefulWidget {
  Buyairtime({Key? key}) : super(key: key);

  @override
  _BuyairtimeState createState() => _BuyairtimeState();
}

class _BuyairtimeState extends State<Buyairtime> {
  String _selectedLocation = "", percent = "0", code = "";
  List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Buying Airtime Error";
  var cmddetails;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    _mockCheckForSession().then((status) async {
      if (status) {
        // loading();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 100), () {});

    return true;
  }

  void getData() async {
    try {
      http.Response response =
          await http.get(parseUrl("airtimeconfig"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        setState(() {
          _region = items.map<Source>((json) {
            return Source.fromJson(json);
          }).toList();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        print(response.body);
        print(response.statusCode);
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
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    } catch (Exception) {
      Navigator.of(context).pop();
      print(Exception);
      var dialog = CustomAlertDialog(
        title: dialogtitle,
        message: nonetwork,
        onPostivePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LandingPage();
              },
            ),
          );
        },
        positiveBtnText: 'Yes',
        // negativeBtnText: 'Ok'
      );
      showDialog(context: context, builder: (BuildContext context) => dialog);
    }
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  void _Buyairtime() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      // loading();
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
        http.Response response = await http.post(parseUrl("buy/airtime"),
            body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          print(cmddetails);
          Navigator.of(context).pop();
          if (cmddetails['status'] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  // return JsonApiDropdown();
                  return LandingPage();
                },
              ),
            );
          } else {
            var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message'],
              onPostivePressed: () {
                if (cmddetails['message']
                    .contains('Insufficient balance. Kindly topup')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // return JsonApiDropdown();
                        return Deposit();
                      },
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              positiveBtnText: 'Continue',
              // negativeBtnText: 'Continue'
            );
            showDialog(
                context: context, builder: (BuildContext context) => dialog);
          }
        } else {
          print(response.body);
          Navigator.of(context).pop();
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: "Contact Admin",
              // onPostivePressed: () {},
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue');
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        }
      } catch (Exception) {
        print(Exception);
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: nonetwork,
            // onPostivePressed: () {},
            // positiveBtnText: 'Ok',
            negativeBtnText: 'Cancel');
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainActivity(
        scaffoldKey: _scaffoldKey,
        child: Paybill(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            // child:Form(
            //   key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Buy Airtime",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Network"),
                        Networklist(),
                        Container(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Amount @ ',
                            style: GoogleFonts.poppins(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${percent}% Discount',
                                  style:
                                      GoogleFonts.poppins(color: Color(primarycolour))),
                            ],
                          ),
                        ),
                        amount(),
                        Container(
                          height: 30,
                        ),
                        Text("Phone Number"),
                        phoneno(),
                      ]),
                ),
                Container(
                  height: 20,
                ),
                RoundedButton(
                  text: "Buy Airtime",
                  press: () {
                    _Buyairtime();
                  },
                ),
              ],
            ),
            // ),
          ),
        ));
  }

  Widget Networklist() {
    return DropdownButtonFormField<Source>(
      items: _region.map((user) {
        return DropdownMenuItem<Source>(
          child: Text(user.name),
          value: user,
        );
      }).toList(),
      value: _currentUser,
      hint: Text('e.g. MTN '),
      onChanged: (Source? salutation) {
        setState(() {
          _currentUser = salutation;
          percent = _currentUser!.id.toString();
          code = _currentUser!.identifier.toString();
        });
      },
      validator: (value) => value == null ? 'field required' : null,
    );
  }

  Widget amount() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      hintText: "e.g 200",
      onChanged: (value) {
        setState(() {
          amountController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value == "0") {
          return "Amount can't be 0";
        }
        return null;
      },
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      hintText: "e.g 0814338xxxxx",
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
        } else if (value.length > 11) {
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
