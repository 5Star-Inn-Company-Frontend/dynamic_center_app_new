// import 'package:dynamic_center/Screens/buyairtime.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/Xchange.dart';
import 'package:dynamic_center/Screens/airtimetocash.dart';
import 'package:dynamic_center/Screens/buyelectricity.dart';
import 'package:dynamic_center/Screens/drawer/main_activity.dart';
import 'package:dynamic_center/Screens/erecharge.dart';
import 'package:dynamic_center/Screens/transfer.dart';
// import 'package:dynamic_center/Screens/buytv.dart';
// import 'package:dynamic_center/Screens/transfer.dart';
import 'package:dynamic_center/general/component/imagebutton.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'buyairtime.dart';
import 'buydata.dart';
import 'buytv.dart';

// import 'buydata.dart';

class LandingPage extends StatefulWidget {
  Widget? child;
  LandingPage({Key? key, this.child}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List data = [];
  String _selectedLocation = "", percent = "0";
  List<Source> _region = [];
  Source? _currentUser;
  bool done = false;
  var cmddetails;
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      getData();
    });
  }

  void getData() async {
    try {
      http.Response response =
          await http.get(parseUrl("transactions"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        setState(() {
          done = true;
        });
        String data = response.body;
        cmddetails = jsonDecode(data);
        // var data1 = cmddetails["data"];
        // print(cmddetails);
        print(cmddetails["data"]);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        setState(() {
          // for (Map i in cmddetails["data"]) {
          //   _region.add(Source.fromJson(i));
          // }
          _region = items.map<Source>((json) {
            return Source.fromJson(json);
          }).toList();
        });
      } else {}
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MainActivity(child: home());
  }

  Widget home() {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 5,
            ),
            Imagebutton(
              text: "Airtime",
              imageaddress: "assets/images/deposit.png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Buyairtime();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Data",
              imageaddress: "assets/images/withdraw.png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // return CameraPreviewScanner();
                      return Buydata();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Transfer",
              imageaddress: "assets/images/send.png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Transfer();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Exchange",
              imageaddress: "assets/images/exchange.png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Xchange();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        Container(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
            ),
            Imagebutton(
              text: "TV",
              imageaddress: "assets/images/deposit(4).png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Buytv();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Airtime2Cash",
              imageaddress: "assets/images/deposit(3).png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Airtimetocash();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Electricity",
              imageaddress: "assets/images/deposit(2).png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Buyelectricity();
                    },
                  ),
                );
              },
            ),
            Imagebutton(
              text: "Recharge Card",
              imageaddress: "assets/images/deposit(1).png",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Buyrechargecard();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            "Latest transactions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        done
            ? Expanded(
                child: _region.length == 0
                    ? Container(
                        width: size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingDialog(),
                          ],
                        ))
                    : ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          final nDataList = _region[index];
                          return InkWell(
                              onTap: () {},
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
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      nDataList.amount,
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  nDataList.date,
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                                                  padding: EdgeInsets.only(
                                                      left: 2, right: 3),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      nDataList.name,
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                )),
                                                Text(
                                                  nDataList.code,
                                                  style: TextStyle(
                                                      color: Color(0xffDF5060)),
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
              )
            : Container(
                height: 350,
              ),
        SizedBox(
          height: 250,
        ),
      ],
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
