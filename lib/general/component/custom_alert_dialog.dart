import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title = "",
    this.message = "",
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText = "",
    this.negativeBtnText = "",
    this.onPostivePressed,
    this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        negativeBtnText.isNotEmpty
            ? TextButton(
                child: Text(negativeBtnText),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNegativePressed != null) {
                    onNegativePressed!();
                  }
                },
              )
            : Container(),
        positiveBtnText.isNotEmpty
            ? TextButton(
                child: Text(positiveBtnText),
                onPressed: () {
                  if (onPostivePressed != null) {
                    onPostivePressed!();
                  }
                },
              )
            : Container(),
      ],
    );
  }
}
