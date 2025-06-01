import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class Imagebutton extends StatelessWidget {
  final String text;
  final String imageaddress;
  final Function press;
  final Color textColor;

  const Imagebutton({
    super.key,
    required this.text,
    required this.imageaddress,
    required this.press,
    this.textColor = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        press();
      },
      child: Column(
        children: [
          Image(
            image: AssetImage(imageaddress),
            height: 50.h,
            width: 50.w,
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              fontSize: 13.5.sp,
              color: textColor,
              
            ),
          ),
        ],
      ),
    );
  }
}
