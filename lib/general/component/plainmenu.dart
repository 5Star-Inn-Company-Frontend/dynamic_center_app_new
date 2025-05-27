import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class Plainmenu extends StatelessWidget {
  final Text text;
  final Function press;
  const Plainmenu({Key? key, required this.text, required this.press})
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
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Row(children: [
            text,
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 20,
              color: Color(0xffB5BBC9),
            ),
          ]),
        ),
      ),
    );
  }
}
