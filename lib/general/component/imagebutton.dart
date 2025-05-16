import 'package:flutter/material.dart';

class Imagebutton extends StatelessWidget {
  final String text;
  final String imageaddress;
  final Function press;
  final Color textColor;

  const Imagebutton({
    Key? key,
    required this.text,
    required this.imageaddress,
    required this.press,
    this.textColor = Colors.black,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: GestureDetector(
        onTap: () {
          press();
        },
        child: Column(
          children: [
            Image(
              image: AssetImage(imageaddress),
              height: 50,
              width: 50,
            ),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
