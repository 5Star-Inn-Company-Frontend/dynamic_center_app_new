// import 'package:dynamic_center/general/constant.dart' as constant;
import 'package:dynamic_center/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';


class DoubleButton extends StatelessWidget {
  final Function? press;
  final String? name;
  final double? width;
  final bool isloading;
  final Color textcolor, buttoncolor, secondbuttoncolor;
  final Widget loaderwidget;
  const DoubleButton(
      {super.key,
      this.press,
      this.name,
      this.width = 200,
      this.textcolor = const Color(primarycolour),
      this.loaderwidget = loadingWidget,
      this.buttoncolor = Colors.white,
      this.isloading = false,
      this.secondbuttoncolor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isloading) {
          return;
        }
        press!();
      },
      child: SizedBox(
        height: 60,
        width: width! + 10,
        child: Stack(
          children: [
            Positioned(
              top: 5,
              // right: 5,
              child: Container(
                height: 50,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondbuttoncolor,
                  border: Border.all(color: buttoncolor),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            Positioned(
              // bottom: 10,
              left: 5,
              child: Container(
                height: 50,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: buttoncolor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: isloading
                    ? loaderwidget
                    : Text(
                        name.toString(),
                        style: GoogleFonts.poppins(
                            color: textcolor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
