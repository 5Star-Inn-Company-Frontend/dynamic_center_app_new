import 'package:flutter/material.dart';

class Backnavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
        onPressed: () {
              Navigator.of(context).pop();
              // Navigator.pop(context, false);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return MyHomePage();
          //     },
          //   ),
          // );
        },
      ),
    );
  }
}
