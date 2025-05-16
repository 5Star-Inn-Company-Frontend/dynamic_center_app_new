import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final Color bgColor;
  final String title, topic, subtopic;
  final int message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  ConfirmDialog({
    this.title = "",
    this.message = 0xffffff,
    required this.topic,
    this.subtopic = "",
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText = "",
    this.negativeBtnText = "",
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(size.height);
    // double  cardheight;
    // if(size.height>=696) {
    //   cardheight = 445*size.height/(size.height+size.width)*0.8;
    // }else if(size.height>=681){
    //   cardheight = size.height*1.2;
    // // }else if(size.height>=565){
    // //   cardheight = size.height*1.3;j
    // }else{
    //   cardheight = 445*size.height/(size.height+size.width);
    // }
    return AlertDialog(
      content: Container(
        // height: cardheight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage("assets/images/verify${title}.png"),
              height: 100,
              width: 100,
            ),
            Text(topic),
            subtopic != null ? Text(subtopic) : Text(""),
          ],
        ),
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        negativeBtnText.isNotEmpty
            ? TextButton(
                child: Card(
                  color: Color(0xffDF5060),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 120,
                    child: Text(negativeBtnText),
                  ),
                ),
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
                child: Card(
                  color: Color(message),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 120,
                    child: Text(positiveBtnText),
                  ),
                ),
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
