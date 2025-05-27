import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class Confirma2cDialog extends StatelessWidget {
  final Color bgColor;
  final String title, topic, subtopic, amount, charges;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function onPostivePressed;
  final Function onNegativePressed;
  final double circularBorderRadius;

  Confirma2cDialog({
    required this.title,
    required this.topic,
    required this.charges,
    required this.amount,
    required this.subtopic,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.onPostivePressed,
    required this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Destination"),
            Text(topic),
            Text("Transaction ID"),
            Text(subtopic),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Amount"),
                    Text(amount),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Fee"),
                    Text(charges),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Total Amount"),
                    Text((int.parse(amount) - int.parse(charges)).toString()),
                  ],
                ),
              ],
            ),
            Divider(),
            Text("Bank Name"),
            Text(subtopic),
            Divider(),
            Text("Account Number"),
            Text(subtopic),
            Divider(),
            Text("Diamond Samuel"),
            TextButton(
              child: Cardlayout(child: Text("Confirm")),
              onPressed: () {},
            )
          ],
        ),
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
    );
  }
}
