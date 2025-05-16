import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {
  final Color bgColor;
  final double circularBorderRadius;

  LoadingDialog({
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 230,
        child:
        SpinKitWave(
          color: Colors.blue,
          type: SpinKitWaveType.start,
          size: 150.0,
        ),
        // CircularProgressIndicator(
        // ),
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),

    );
  }
}