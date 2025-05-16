import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      // width: size.width * 0.8,
      // constraints: BoxConstraints.expand(),
      width: size.width * 0.4,
      height: size.height * 0.1,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Button.png"),
              fit: BoxFit.cover)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: () {
            press();
          },
          child: Text(
            text,
            style: TextStyle(color: Color(primarycolour)),
          ),
        ),
      ),
    );
  }
}
