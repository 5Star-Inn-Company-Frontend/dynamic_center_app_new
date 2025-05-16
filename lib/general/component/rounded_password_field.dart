import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final FormFieldValidator validate;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String label;
  final Function press;
  final bool obscureText;
  const RoundedPasswordField({
    Key? key,
    required this.obscureText,
    required this.onChanged,
    required this.press,
    this.label = "password",
    required this.validate,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        // controller: _userPasswordController,
        onChanged: onChanged,
        obscureText: obscureText, //
        controller: controller, // This will obscure text dynamically
        decoration: InputDecoration(
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
        ),
        validator: validate,
      ),
    );
  }
}
