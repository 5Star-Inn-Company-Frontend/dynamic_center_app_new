import 'dart:convert';
import 'dart:io';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/plainmenu.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:http/http.dart' as http;

class Termsandcondition extends StatefulWidget {
  Termsandcondition({Key? key}) : super(key: key);

  @override
  _TermsandconditionState createState() => _TermsandconditionState();
}

class _TermsandconditionState extends State<Termsandcondition> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("TERMS & CONDITION",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(top: 50,),
             child: Cardlayout(
                child: Column(
                  children: [
                    Text("CUSTOMER TERMS & CONDITIONS"),
                    Text("IMPORTANT:"),
                    SizedBox(height: 20,),
                    Text("THESE TERMS AND CONDITIONS (“Conditions”) "
                        "DEFINE THE BASIS UPON WHICH GETT WILL PROVIDE YOU WITH "
                        "ACCESS TO THE GETT MOBILE APPLICATION PLATFORM, PURSUANT "
                        "TO WHICH YOU WILL BE ABLE TO REQUEST CERTAIN "
                        "TRANSPORTATION SERVICES FROM THIRD PARTY DRIVERS BY "
                        "PLACING ORDERS THROUGH GETT’S MOBILE APPLICATION PLATFORM. "
                        "THESE CONDITIONS (TOGETHER WITH THE DOCUMENTS REFERRED TO "
                        "HEREIN) SET OUT THE TERMS OF USE ON WHICH YOU MAY, AS A "
                        "CUSTOMER, USE THE APP AND REQUEST TRANSPORTATION SERVICES."
                        " BY USING THE APP AND TICKING THE ACCEPTANCE BOX, YOU "
                        "INDICATE THAT YOU ACCEPT THESE TERMS OF USE WHICH APPLY, "
                        "AMONG OTHER THINGS, TO ALL SERVICES HEREINUNDER TO BE "
                        "RENDERED TO OR BY YOU VIA THE APP WITHIN THE UK AND "
                        "THAT YOU AGREE TO ABIDE BY THEM. USE THE APP AND "
                        "REQUEST TRANSPORTATION SERVICES. BY USING THE APP "
                        "AND TICKING THE ACCEPTANCE BOX, YOU INDICATE THAT "
                        "YOU ACCEPT THESE TERMS OF USE WHICH APPLY, AMONG OTHER "
                        "THINGS, TO ALL SERVICES HEREINUNDER TO BE RENDERED TO OR "
                        "BY YOU VIA THE APP WITHIN THE UK AND THAT YOU AGREE TO "
                        "ABIDE BY THEM."),

                  ],
                )
             ),
          ),
        ),
    );
  }
}