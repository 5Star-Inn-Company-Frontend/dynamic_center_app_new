import 'package:dynamic_center/Screens/FAQ.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/plainmenu.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class Support extends StatefulWidget {
  Support({Key? key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text("Support",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          // height: 1000,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.17),
                // Expanded(
                //   child:
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Plainmenu(
                        text: Text("Frequently asked questions",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                        ),
                        press: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return FAQ();
                                },
                              ),
                            );
                        },
                      ),
                      Plainmenu(
                        text: Text("Your support tickets",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                        ),
                        press: (){
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) {
                          //         return PersonalInformation();
                          //       },
                          //     ),
                          //   );
                        },
                      ),
                      Plainmenu(
                        text: Text("Contact us",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                        ),
                        press: (){
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) {
                          //         return PersonalInformation();
                          //       },
                          //     ),
                          //   );
                        },
                      ),
                      ]
                  ),
                ),
                // ),
              ]
          ),
        ),
      ),
    );
  }
}