import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';

class Cardlayout extends StatelessWidget {
  final Widget child;
  const Cardlayout({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(25.0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: child,
    );
  }
}
