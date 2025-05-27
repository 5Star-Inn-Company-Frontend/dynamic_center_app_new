import 'dart:convert';
import 'dart:io';

// import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/Screens/paybill.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
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

class Transfer extends StatefulWidget {
  Transfer({Key? key}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _selectedLocation = "", percent = "0";
  List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Transfer Error";
  var cmddetails;
  bool bank = false, user = false;
  //creating Key for red panel
  GlobalKey _keyRed = GlobalKey();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var _locations = [
    "User to user",
    "User to bank",
  ];
  final _formKey3 = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {});
  }

  void getData() async {
    try {
      loading();
      http.Response response =
          await http.get(parseUrl("banktransferconfig"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        // var data1 = cmddetails["data"];
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
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    } catch (Exception) {
      Navigator.of(context).pop();
      var dialog = CustomAlertDialog(
        title: dialogtitle,
        message: nonetwork,
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
        positiveBtnText: 'ok',
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

  void _Transfer(email) async {
    if (_formKey3.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        http.Response response;
        if (email.length == 11) {
          var json_body = {
            'username': email,
          };
          response = await http.post(parseUrl("validateuseraccount"),
              body: json_body,
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
        } else {
          var json_body = {
            'account_number': email,
            'bank_code': percent,
          };
          response = await http.post(parseUrl("validatebankaccount"),
              body: json_body,
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
        }
        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          print(cmddetails);
          Navigator.of(context).pop();
          if (cmddetails['status'] == 1) {
            var dialog;
            if (email.length == 11) {
              dialog = ConfirmDialog(
                  title: "Success",
                  topic: cmddetails['message'],
                  subtopic: "Account Name: ${cmddetails['data']}",
                  message: 0xff75BF72,
                  onPostivePressed: () {},
                  positiveBtnText: 'Subscribe 😀',
                  negativeBtnText: 'Cancel 🥺');
              showDialog(
                  context: context, builder: (BuildContext context) => dialog);
            } else {
              dialog = ConfirmDialog(
                  title: "Success",
                  topic: cmddetails['message'],
                  subtopic:
                      "Account Name: ${cmddetails['data']["account_name"]}"
                      "\n Account Number: ${cmddetails['data']["account_number"]}",
                  message: 0xff75BF72,
                  onPostivePressed: () {},
                  positiveBtnText: 'Subscribe 😀',
                  negativeBtnText: 'Cancel 🥺');
              showDialog(
                  context: context, builder: (BuildContext context) => dialog);
            }
            // Scaffold
            //     .of(context)
            //     .showSnackBar(SnackBar(content: Text('You can now login')));
          } else {
            var dialog = ConfirmDialog(
              title: "failed",
              topic: "Verification Error!!",
              message: 0xffDF5060,
              onPostivePressed: () {
                Navigator.of(context).pop();
                _Transfer(phoneController.text);
              },
              positiveBtnText: 'Retry 😱',
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
            negativeBtnText: 'ok');
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
        scaffoldKey: _scaffoldKey,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: 800,
            child: Paybill(
              child: Container(
                key: _keyRed,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Transfer",
                      style:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      height: 20,
                    ),
                    Form(
                      key: _formKey3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type"),
                            type(),
                            Container(
                              height: 20,
                            ),
                            Visibility(
                              visible: bank,
                              child: Text("Bank name"),
                            ),
                            Visibility(
                              visible: bank,
                              child: Networklist(),
                            ),
                            Container(
                              height: 20,
                            ),
                            Text("Amount"),
                            amount(),
                            Container(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("Phone No/ Account No | Samji"),
                                Spacer(),
                                Visibility(
                                  child: GestureDetector(
                                    onTap: () {
                                      scan();
                                    },
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/ic_scan.png"),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  visible: user,
                                ),
                                Visibility(
                                  child: GestureDetector(
                                      onTap: () {
                                        scan();
                                      },
                                      child: Text("Scan QR")),
                                  visible: user,
                                ),
                              ],
                            ),
                            phoneno(),
                          ]),
                    ),
                    Container(
                      height: 20,
                    ),
                    RoundedButton(
                      text: "Verify",
                      press: () {
                        _Transfer(phoneController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
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
      hint: Text('e.g. firstbank'),
      onChanged: (Source? salutation) => setState(() {
        _currentUser = salutation;
        print(_currentUser!.id);
        percent = _currentUser!.id.toString();
      }),
      validator: (value) => value == null ? 'field required' : null,
    );
  }

  Widget type() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      hint: Text('e.g. User 2 User '),
      onChanged: (salutation) {
        _region.clear();
        if (salutation == "User to bank") {
          setState(() {
            user = false;
            bank = true;
          });
          getData();
        } else {
          setState(() {
            user = true;
            bank = false;
          });
        }
        setState(() {
          _selectedLocation = salutation!;
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
        } else if (value.length < 10 || value.length > 11) {
          return "incorrect Phone Number or Account Number";
        }
        return null;
      },
    );
  }

  String barcode = "";
  Future scan() async {
    // try {
    //   String barcode = await BarcodeScanner.scan();
    //   setState(() => this.barcode = barcode);
    //   // print("my qrcode "+barcode);
    //   Snackbar.showMessage(barcode, _scaffoldKey);
    //   // Navigator.pop(context);
    // } on PlatformException catch (e) {
    //   if (e.code == BarcodeScanner.CameraAccessDenied) {
    //     setState(() {
    //       this.barcode = 'The user did not grant the camera permission!';
    //     });
    //   } else {
    //     setState(() => this.barcode = 'Unknown error: $e');
    //   }
    // } on FormatException {
    //   setState(() => this.barcode =
    //       'null (User returned using the "back"-button before scanning anything. Result)');
    // } catch (e) {
    //   setState(() => this.barcode = 'Unknown error: $e');
    // }
  }
}

class Source {
  String id;
  String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["code"] as String,
      name: json["name"] as String,
    );
  }
}
