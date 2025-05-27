import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class Roundedmenu extends StatelessWidget {
  final Text text;
  final Function press;
  final Widget icon;
  const Roundedmenu(
      {Key? key,
      required this.text,
      this.icon = const Text(""),
      required this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        press();
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
            margin: EdgeInsets.only(right: 30, left: 30),
            child: Row(children: [
              icon,
              text,
              Spacer(),
              Icon(
                Icons.arrow_forward,
                size: 20,
                color: Color(0xffB5BBC9),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
