import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 15.sp),
        ),
        GestureDetector(
          onTap: () {
            press();
          },
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: GoogleFonts.poppins(
              color: Color(primarycolour),
              fontWeight: FontWeight.bold,
              fontSize: 15.sp
            ),
          ),
        )
      ],
    );
  }
}
