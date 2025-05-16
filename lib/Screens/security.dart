import 'package:dynamic_center/Screens/change_password.dart';
import 'package:dynamic_center/Screens/two_factor_verification.dart';
import 'package:dynamic_center/general/SizeConfig.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/roundedmenu.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  Security({Key? key}) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text("Security",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: cardheight(context:context, needed: true),
          // height: 1000,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Image(
                  image: AssetImage("assets/images/security.png"),
                ),
                Expanded(
                  child:
                Cardlayout(
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30,),
                          Roundedmenu(
                            text: Text("Change Password",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                            ),
                            press: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChangePassword();
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Roundedmenu(
                            text: Text("Change PIN",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                            ),
                            press: (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return PersonalInformation();
                              //     },
                              //   ),
                              // );
                            },
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap:  (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return PersonalInformation();
                              //     },
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 60,
                              margin: EdgeInsets.only(right: 5, left: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                color: Color(scafoldcolour),
                                child: Container(
                                  margin: EdgeInsets.only(right: 10, left: 10),
                                  child: Row(
                                      children:[
                                        Text("Two-Factor Verification",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                                        ),
                                        Spacer(),
                                        Switch(
                                          value: isSwitched,
                                          onChanged: (value){
                                            setState(() {
                                              isSwitched=value;
                                              // print(isSwitched);
                                            });
                                            if (isSwitched){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>TwoFactorVerification(),
                                                  ));
                                            }
                                          },
                                          activeTrackColor: Color(primarycolour),
                                          activeColor: Colors.green,
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 60),

                        ],
                      ),
                  ),
                ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}