import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/FAQdetails.dart';
import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/plainmenu.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FAQ extends StatefulWidget {
  FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  String _selectedLocation = " ", percent = "0";
  List<Source> _region = [];
  String dialogtitle = "Transfer Error";
  var cmddetails;
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
      // http.Response response = await http.get('${Baseurl}faq',
      http.Response response =
          await http.get(parseUrl("companydetails"), headers: {
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
          // _region = items.map<Source>((json) {
          //   return Source.fromJson(json);
          // }).toList();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        // Fluttertoast.showToast(
        //     msg: "Contact Admin",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ'S",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Cardlayout(
            child:
                // Column(
                //   children: [
                //     SizedBox(height: 30,),
                //     Text("Account",
                //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                //     ),
                //     SizedBox(height: 30,),
                //     Plainmenu(
                //       text: Text("Unblock account",
                //         style: TextStyle(fontSize: 19, color: Colors.black),
                //       ),
                //       press: (){
                //         //   Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) {
                //         //         return PersonalInformation();
                //         //       },
                //         //     ),
                //         //   );
                //       },
                //     ),
                //     Plainmenu(
                //       text: Text("Change phone number ",
                //         style: TextStyle(fontSize: 19, color: Colors.black),
                //       ),
                //       press: (){
                //         //   Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) {
                //         //         return PersonalInformation();
                //         //       },
                //         //     ),
                //         //   );
                //       },
                //     ),
                //     Plainmenu(
                //       text: Text("Privacy information",
                //         style: TextStyle(fontSize: 19, color: Colors.black),
                //       ),
                //       press: (){
                //         //   Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) {
                //         //         return PersonalInformation();
                //         //       },
                //         //     ),
                //         //   );
                //       },
                //     ),
                //     SizedBox(height: 30,),
                //     Text("Payment and pricing",
                //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                //     ),
                //     SizedBox(height: 30,),
                //     Plainmenu(
                //       text: Text("Accepted payment methods",
                //         style: TextStyle(fontSize: 19, color: Colors.black),
                //       ),
                //       press: (){
                //         //   Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) {
                //         //         return PersonalInformation();
                //         //       },
                //         //     ),
                //         //   );
                //       },
                //     ),
                //     Plainmenu(
                //       text: Text("Price estimation",
                //         style: TextStyle(fontSize: 19, color: Colors.black),
                //       ),
                //       press: (){
                //         //   Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) {
                //         //         return PersonalInformation();
                //         //       },
                //         //     ),
                //         //   );
                //       },
                //     ),
                //   ],
                // )
                _region.length == 0
                    ? SizedBox(
                        height: 30,
                      )
                    : Container(
                        height: size.height,
                        child: ListView.builder(
                            itemCount: _region.length,
                            itemBuilder: (BuildContext context, int index) {
                              final nDataList = _region[index];
                              return Plainmenu(
                                text: Text(
                                  nDataList.code,
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.black),
                                ),
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return FAQdetails(
                                          Details: nDataList.name.toString(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            })),
          ),
        ),
      ),
    );
  }
}

class Source {
  int id;
  String code;
  String name;

  Source({required this.id, required this.name, required this.code});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["id"] as int,
      code: json["title"] as String,
      name: json["content"] as String,
    );
  }
}
