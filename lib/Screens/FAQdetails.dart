import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class FAQdetails extends StatefulWidget {
  String Details;
  FAQdetails({Key? key, required this.Details}) : super(key: key);

  @override
  _FAQdetailsState createState() => _FAQdetailsState();
}

class _FAQdetailsState extends State<FAQdetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ'S Details",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        margin: EdgeInsets.only(
          top: 50,
        ),
        child: Cardlayout(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Text(widget.Details),
            ),
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
