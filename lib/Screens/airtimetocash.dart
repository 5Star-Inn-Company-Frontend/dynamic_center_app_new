import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/home/landing_page.dart';
import 'package:dynamic_center/Screens/paybill.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Airtimetocash extends StatefulWidget {
  const Airtimetocash({super.key});

  @override
  State<Airtimetocash> createState() => _AirtimetocashState();
}

class _AirtimetocashState extends State<Airtimetocash> {
  String _selectedLocation = "", percent = "0";
  final List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Airtime2Cash Error";
  var cmddetails;
  final _formKey = GlobalKey<FormState>();
  final _locations = [
    "Wallet",
    "Bank",
  ];
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  bool bank = false;
  @override
  void initState() {
    super.initState();
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  void _Airtimetocash() async {
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
          'amount': amountController.text,
          'version': appversion,
          'dest': _selectedLocation,
          'bank': bankController.text,
        };
        http.Response response = await http.post(parseUrl("buy/a2c"),
            body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
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
            // Scaffold
            //     .of(context)
            //     .showSnackBar(SnackBar(content: Text('You can now login')));
          } else {
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
                negativeBtnText: 'Continue');
            showDialog(
                context: context, builder: (BuildContext context) => dialog);
          }
        } else {
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
        Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return MainActivity(
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
              height: 30,
            ),
            Text(
              "Airtime2Cash",
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
                    Text("Amount "),
                    amount(),
                    Container(
                      height: 20,
                    ),
                    Text("Sender Phone Number"),
                    phoneno(),
                    Container(
                      height: 20,
                    ),
                    Text("To"),
                    Networklist(),
                    Visibility(
                      visible: bank,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                          ),
                          Text("Account number | Bank"),
                          bankdetails(),
                        ],
                      ),
                    ),
                  ]),
            ),
            Container(
              height: 20,
            ),
            RoundedButton(
              text: "Submit Now",
              press: () {
                _Airtimetocash();
              },
            ),
          ],
        ),
        // ),
      ),
    ));
  }

  Widget Networklist() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      hint: Text('e.g. Wallet '),
      onChanged: (salutation) {
        _region.clear();
        setState(() {
          _selectedLocation = salutation!;
        });
        if (salutation == "Bank") {
          setState(() {
            bank = true;
          });
        } else {
          setState(() {
            bank = false;
            bankController.text = "null";
          });
        }
      },
      validator: (value) => value == null ? 'field required' : null,
      items: _locations.map((location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
    );
  }

  Widget amount() {
    return RoundedInputField(
      hintText: "e.g 200",
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
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

  Widget phoneno() {
    return RoundedInputField(
      hintText: "e.g 0814338xxxxx",
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
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

  Widget bankdetails() {
    return RoundedInputField(
      hintText: "e.g 02482***** | GTB",
      onChanged: (value) {
        setState(() {
          bankController.text = value;
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
}

class Source {
  int id;
  String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["price"] as int,
      name: json["code"] as String,
    );
  }
}
