import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/landing_page.dart';
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

import 'drawer/main_activity.dart';

class Buydata extends StatefulWidget {
  Buydata({Key? key}) : super(key: key);

  @override
  _BuydataState createState() => _BuydataState();
}

class _BuydataState extends State<Buydata> {
  String _selectedLocation = "";
  var _locations = [
    "Mtn",
    "Glo",
    "Etisalat",
    "Airtel",
  ];
  List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Error in buying Data", code = "";
  var cmddetails;
  TextEditingController phoneController = TextEditingController();
  final _formdata = GlobalKey<FormState>();

  void getData() async {
    try {
      loading();
      http.Response response =
          await http.get(parseUrl("dataconfig/${_selectedLocation}"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        print(cmddetails);
        setState(() {
          _region = items.map<Source>((json) {
            return Source.fromJson(json);
          }).toList();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: cmddetails["message"],
          onPostivePressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       // return JsonApiDropdown();
            //       return Login();
            //     },
            //   ),
            // );
          },
          positiveBtnText: 'Continue',
          // negativeBtnText: 'No'
        );
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    } catch (Exception) {
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
          negativeBtnText: 'Ok');
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

  void _buydata() async {
    if (_formdata.currentState!.validate()) {
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
        };
        http.Response response = await http.post(parseUrl("buy/data"),
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
              message: "Connection Error",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
              ),
              Text(
                "Buy Data",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),
                textAlign: TextAlign.left,
              ),
              Container(
                height: 20,
              ),
              Form(
                key: _formdata,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Network"),
                      Networklist(),
                      Container(
                        height: 30,
                      ),
                      Text("Select Data Plan"),
                      Datalist(),
                      Container(
                        height: 30,
                      ),
                      Text("Phone Number"),
                      phoneno(),
                    ]),
              ),
              Container(
                height: 30,
              ),
              RoundedButton(
                text: "Buy Data",
                press: () {
                  _buydata();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Networklist() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      hint: Text('e.g. MTN '),
      onChanged: (salutation) {
        _region.clear();
        setState(() {
          _selectedLocation = salutation!;
          getData();
        });
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

  Widget Datalist() {
    return DropdownButtonFormField<Source>(
      items: _region.map((user) {
        return DropdownMenuItem<Source>(
          child: Text("${user.desc} ${user.id}"),
          value: user,
        );
      }).toList(),
      value: _currentUser,
      hint: Text('e.g. MTN 1GB  - #300'),
      onChanged: (Source? salutation) => setState(() {
        _currentUser = salutation;
        code = _currentUser!.name;
      }),
      validator: (value) => value == null ? 'field required' : null,
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      hintText: "e.g. 0814338xxxx",
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
}

class Source {
  int id;
  String name;
  String desc;

  Source({required this.id, required this.name, required this.desc});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["price"] as int,
      name: json["identifier"] as String,
      desc: json["desc"] as String,
    );
  }
}
