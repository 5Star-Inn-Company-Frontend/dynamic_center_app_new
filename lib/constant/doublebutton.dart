import 'package:flutter/material.dart';

import 'constant.dart';

class DoubleButton extends StatelessWidget {
  final Function? press;
  final String? name;
  final double? width;
  final bool isloading;
  final Color textcolor, buttoncolor, secondbuttoncolor;
  final Widget loaderwidget;
  const DoubleButton(
      {Key? key,
      this.press,
      this.name,
      this.width = 200,
      this.textcolor = primarycolour,
      this.loaderwidget = loadingWidget,
      this.buttoncolor = Colors.white,
      this.isloading = false,
      this.secondbuttoncolor = Colors.white})
      : super(key: key);

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
                        style: TextStyle(
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
