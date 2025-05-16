import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer/main_activity.dart';

class Transaction extends StatefulWidget {
  Transaction({Key? key}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String _selectedLocation = "", percent = "0";
  List<Source> _region = [];
  String dialogtitle = "Transfer Error";
  var cmddetails;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      getData();
    });
  }

  void getData() async {
    try {
      loading();
      http.Response response =
          await http.get(parseUrl("transactions"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        // var data1 = cmddetails["data"];
        print(cmddetails);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        setState(() {
          // for(Map i in cmddetails["data"]){
          //   _region.add(Source.fromJson(i));
          // }
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

  void gettransactindetails() async {
    try {
      loading();
      http.Response response =
          await http.get(parseUrl("transaction/$_selectedLocation"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        // var data1 = cmddetails["data"];
        print(cmddetails);
        // final items = cmddetails["data"].cast<Map<String, dynamic>>();
        // setState(() {
        //   for(Map i in cmddetails["data"]){
        //     _region.add(Source.fromJson(i));
        //   }
        //   // _region = items.map<Source>((json) {
        //   //   return Source.fromJson(json);
        //   // }).toList();
        // });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MainActivity(
      currentIndex: 0,
      key: _scaffoldKey,
      child: _region.length == 0
          ? SizedBox(
              height: 30,
            )
          : ListView.builder(
              itemCount: _region.length,
              itemBuilder: (BuildContext context, int index) {
                final nDataList = _region[index];
                return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLocation = nDataList.id.toString();
                      });
                      gettransactindetails();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: Color(scafoldcolour),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            nDataList.type == "debit"
                                ? Image(
                                    image: AssetImage(
                                        "assets/images/arrow-up-left-circle.png"),
                                    height: 40,
                                    width: 40,
                                  )
                                : Image(
                                    image: AssetImage(
                                        "assets/images/arrow-down-right-circle.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            nDataList.amount,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        nDataList.date,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 2, right: 3),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            nDataList.name,
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ),
                                      )),
                                      Text(
                                        nDataList.code,
                                        style:
                                            TextStyle(color: Color(0xffDF5060)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              }),
    );
  }
}

class Source {
  int id;
  String code;
  String name;
  String date;
  String amount;
  String type;

  Source(
      {required this.id,
      required this.name,
      required this.date,
      required this.amount,
      required this.type,
      required this.code});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["id"] as int,
      code: json["code"] as String,
      name: json["description"] as String,
      date: json["date"] as String,
      amount: json["amount"] as String,
      type: json["type"] as String,
    );
  }
}
