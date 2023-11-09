import 'package:flutter/material.dart';
import 'package:msku2209b/theme.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? label;
  final String? labelText;
  final Color labelColor;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final void Function()? onTap;
  final TextAlign textAlign;
  final int? minLine;
  final int? maxline;
  final Color borderColor;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.suffixText,
    this.suffixIcon,
    this.prefixIcon,
    this.label,
    this.labelText,
    this.labelColor = CColors.white,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.textAlign = TextAlign.left,
    this.minLine,
    this.maxline = 1,
    this.borderColor = CColors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          minLines: minLine,
          maxLines: maxline,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          validator: validator,
          autofocus: false,
          textAlign: textAlign,
          onTap: onTap,
          style: const TextStyle(color: CColors.black),
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            suffixText: suffixText,
            hintStyle: const TextStyle(fontSize: 17),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: CColors.grey, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
