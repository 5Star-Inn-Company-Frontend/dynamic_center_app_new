import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double defaultSize = 0.0;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

double cardheight(
    {required BuildContext context,
    double addheight = 0,
    bool needed = false}) {
  double screenHeight = MediaQuery.of(context).size.height;
  // print(screenHeight);
// double screenHeight = SizeConfig.screenHeight;
  if (needed) {
    if (screenHeight >= 1098) {
      return screenHeight;
    } else if (screenHeight >= 988) {
      return screenHeight * (1.1 + addheight);
    } else if (screenHeight >= 860) {
      return screenHeight * (1.2 + addheight);
    } else if (screenHeight >= 734) {
      return screenHeight * (1.4 + addheight);
    } else if (screenHeight >= 681) {
      return screenHeight * (1.8 + addheight);
    } else if (screenHeight >= 565) {
      return screenHeight * (2.3 + addheight);
    } else {
      return screenHeight * 2.4;
    }
  } else {
    if (screenHeight >= 988) {
      return screenHeight;
    } else if (screenHeight >= 860) {
      return screenHeight * (1.2 + addheight);
    } else if (screenHeight >= 734) {
      return screenHeight * (1.4 + addheight);
    } else if (screenHeight >= 681) {
      return screenHeight * (1.8 + addheight);
    } else if (screenHeight >= 565) {
      return screenHeight * (2.3 + addheight);
    } else {
      return screenHeight * (1.4 + addheight);
    }
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
