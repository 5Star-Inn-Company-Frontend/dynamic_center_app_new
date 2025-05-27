import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        press();
      },
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          color: Color(primarycolour),
          borderRadius: BorderRadius.circular(12.r),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/Button.png"),
          //   fit: BoxFit.cover)
        ),
        child: Center(
          child: Text(
              text,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
        ),
      ),
    );
  }
}
