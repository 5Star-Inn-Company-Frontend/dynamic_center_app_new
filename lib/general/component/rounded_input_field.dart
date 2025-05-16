import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatelessWidget {
  final String labelText, initialValue, hintText, prefixText;
  final IconData icon;
  final bool enableInteractiveSelection;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator validate;
  final List<TextInputFormatter>? inputFormatters;
  const RoundedInputField({
    Key? key,
    this.labelText = "",
    this.hintText = "",
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
    this.prefixText = "",
    this.onTap,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.keyboardType = TextInputType.text,
    this.initialValue = "",
    this.inputFormatters,
    required this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: Color(primarycolour),
        controller: controller,
        initialValue: initialValue,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixText: prefixText,
          // border: InputBorder.none,
        ),
        focusNode: focusNode,
        enableInteractiveSelection:
            enableInteractiveSelection ? enableInteractiveSelection : false,
        validator: validate,
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
      ),
    );
  }
}
