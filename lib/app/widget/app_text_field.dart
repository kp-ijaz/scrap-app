// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.icon,
    this.keyBoardType,
    this.controller,
    this.inputFormatter,
    this.onChange,
    this.onTap,
    this.prefixIcon,
    this.readOnly = false,
    this.obSecureText = false,
    this.suffixIcon,
    this.fillColor = const Color(0xFFEEEEEE),
    this.validator,
    this.initialValue,
  });
  final String hintText;
  final Icon? icon;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;
  final Function(String)? onChange;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Color fillColor;
  final bool readOnly;
  final bool obSecureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyBoardType,
      controller: controller,
      inputFormatters: inputFormatter,
      onChanged: onChange,
      onTap: onTap,
      readOnly: readOnly,
      obscureText: obSecureText,
      validator: validator,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: prefixIcon,
          icon: icon ?? null,
          hintText: hintText,
          filled: true,
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFFB8B8B8)),
          border: InputBorder.none),
    );
  }
}
