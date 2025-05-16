import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginoptionButton extends StatelessWidget {
  final Function press;
  final String images;
  const LoginoptionButton({
    Key? key,
    required this.press,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      // width: size.width * 0.8,
      // constraints: BoxConstraints.expand(),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(images), fit: BoxFit.cover)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Container(),
          onPressed: () {
            press();
          },
        ),
      ),
    );
  }
}
