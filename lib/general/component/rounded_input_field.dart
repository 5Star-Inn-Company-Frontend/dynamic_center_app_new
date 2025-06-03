import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String labelText, hintText, prefixText;
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
    super.key,
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
    // this.initialValue = "",
    this.inputFormatters,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Color(primarycolour),
      controller: controller,
      // initialValue: initialValue,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: GoogleFonts.poppins(fontSize: 12.sp,color: Colors.grey,),
        labelStyle: GoogleFonts.poppins(fontSize: 12.sp,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(primarycolour)),
        ),
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
    );
  }
}
