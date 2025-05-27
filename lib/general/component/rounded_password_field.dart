import 'package:dynamic_center/constant/imports.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final FormFieldValidator validate;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String label;
  final Function press;
  final bool obscureText;
  const RoundedPasswordField({
    super.key,
    required this.obscureText,
    required this.onChanged,
    required this.press,
    this.label = "Password",
    required this.validate,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // controller: _userPasswordController,
      onChanged: onChanged,
      obscureText: obscureText, //
      controller: controller, // This will obscure text dynamically
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.poppins(fontSize: 12.sp,color: Colors.grey,),
        labelStyle: GoogleFonts.poppins(fontSize: 12.sp,),
        labelText: label,
        // hintText: 'Enter your password',
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            press();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(primarycolour)),
        ),
      ),
      validator: validate,
    );
  }
}
