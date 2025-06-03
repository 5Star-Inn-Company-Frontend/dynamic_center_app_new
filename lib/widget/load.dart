import 'package:dynamic_center/constant/colors.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';

class LoadButton extends StatelessWidget {
  final VoidCallback function;
  final String label;
  final double? width;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  const LoadButton(
      {required this.label,
      super.key,
      this.fontSize,
      this.borderColor,
      this.fontWeight,
      required this.function,
      this.width,
      this.textColor,
      this.height,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46.h,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          color: color ?? primaryColor,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(10.r)),
      child: TextButton(
        onPressed: function,
        child: Text(
          label,
          style: GoogleFonts.merriweatherSans(
            color: textColor ?? Colors.white,
            fontWeight: fontWeight ?? FontWeight.w700,
            fontSize: fontSize ?? 16.sp,
          ),
        ),
      ),
    );
  }
}
