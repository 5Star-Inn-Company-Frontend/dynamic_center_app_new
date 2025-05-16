import 'package:flutter/material.dart';

class Paybill extends StatelessWidget {
  final Widget child;
  const Paybill({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height;
    height = 600;
    return Container(
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 40.0,
          right: 40.0,
          child: Cardlayout(
            color: Color(0xffE3EDF7),
            child: Container(
              height: height,
              width: size.width,
              // child: child,
            ),
          ),
        ),
        // Expanded(
        //   child:
        Positioned(
          top: 20.0,
          right: 20,
          child: Cardlayout(
            color: Color(0xffE3EDF7),
            child: Container(
              height: height,
              width: size.width,
              // child: child,
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Cardlayout(
            color: Color(0xffE3EDF7),
            child: Container(
              width: size.width,
              height: height,
              child: child,
            ),
          ),
        ),
        // ),
      ]),
    );
  }
}

class Cardlayout extends StatelessWidget {
  final Widget child;
  final Color color;
  const Cardlayout({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: color,
      child: child,
    );
  }
}
