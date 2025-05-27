import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class CircularImage extends StatelessWidget {
  final double _width, _height;
  final ImageProvider image;

  CircularImage(this.image, {double width = 40, double height = 40})
      : _width = width,
        _height = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: image, fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
            )
          ]),
    );
  }
}
