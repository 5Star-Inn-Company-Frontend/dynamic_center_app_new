import 'package:flutter/material.dart';

class Cardlayout extends StatelessWidget {
  final Widget child;
  const Cardlayout({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(25.0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: child,
    );
  }
}
