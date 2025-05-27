import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/Screens/paybill.dart';
import 'package:dynamic_center/general/component/confirm_dialog.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Buytv extends StatefulWidget {
  Buytv({Key? key}) : super(key: key);

  @override
  _BuytvState createState() => _BuytvState();
}

class _BuytvState extends State<Buytv> {
  String _selectedLocation = "", code = "", provider = "";
  var _locations = [
    "DSTV",
    "GOTV",
    "STARTIMES",
  ];
  List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Error in buying Data";
  var cmddetails;
  TextEditingController phoneController = TextEditingController();
  final _formdata = GlobalKey<FormState>();

  void getData() async {
    try {
      loading();
      http.Response response =
          await http.get(parseUrl("tvconfig/${_selectedLocation}"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
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
        var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: "Contact Admin",
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

  void _verifytv() async {
    if (_formdata.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'iuc': phoneController.text,
          'provider': _selectedLocation,
        };
        http.Response response = await http.post(parseUrl("validatetv"),
            body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          print(cmddetails);
          Navigator.of(context).pop();
          if (cmddetails['status'] == 1) {
            var dialog = ConfirmDialog(
                title: "success",
                topic: "Verified Successfully!!",
                subtopic: cmddetails['message'],
                message: 0xff75BF72,
                onPostivePressed: () {
                  _Buytv();
                },
                positiveBtnText: 'Subscribe 😀',
                negativeBtnText: 'Cancel 🥺');
            showDialog(
                context: context, builder: (BuildContext context) => dialog);
          } else {
            var dialog = ConfirmDialog(
              title: "failed",
              topic: cmddetails['message'],
              message: 0xffDF5060,
              onPostivePressed: () {
                Navigator.of(context).pop();
                _verifytv();
              },
              positiveBtnText: 'Retry 🥺',
              // negativeBtnText: 'Retry 🥺'
            );
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
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  void _Buytv() async {
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
        http.Response response = await http.post(parseUrl("buy/paytv"),
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
          // child:Form(
          //   key: _formdata,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "TV",
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
                      Text("Select Provider"),
                      Networklist(),
                      Container(
                        height: 20,
                      ),
                      Text("Select Provider Plan"),
                      Datalist(),
                      Container(
                        height: 20,
                      ),
                      Text("IUC Number "),
                      phoneno(),
                    ]),
              ),
              Container(
                height: 20,
              ),
              RoundedButton(
                text: "Verify",
                press: () {
                  _verifytv();
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
      hint: Text('e.g. DSTV '),
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
          child: Text("${user.type} ${user.id}"),
          value: user,
        );
      }).toList(),
      value: _currentUser,
      hint: Text('e.g. GoTV Max  - #3,200'),
      onChanged: (Source? salutation) => setState(() {
        _currentUser = salutation;
        code = _currentUser!.name.toString();
        provider = _currentUser!.provider;
      }),
      validator: (value) => value == null ? 'field required' : null,
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      hintText: "e.g. 43800xxxx",
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
  String provider;
  String type;
  String code;

  Source(
      {required this.id,
      required this.name,
      required this.provider,
      required this.type,
      required this.code});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["price"] as int,
      name: json["code"] as String,
      provider: json["provider"] as String,
      type: json["desc"] as String,
      code: json["identifier"] as String,
    );
  }
}
