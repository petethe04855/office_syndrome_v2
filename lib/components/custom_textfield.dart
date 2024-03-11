import 'package:flutter/material.dart';

// customTextField เป็น widget ที่เราสร้างขึ้นมาเอง
// โดยมีการรับค่าต่างๆ มาจากภายนอก
// และส่งค่าต่างๆ กลับไปยังภายนอก
Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required Icon? prefixIcon,
  required bool obscureText,
  TextInputType textInputType = TextInputType.text,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    autofocus: false,
    enableSuggestions: false,
    autocorrect: false,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    ),
    validator: validator,
  );
}

Widget customTextFieldEdit({
  required TextEditingController controller,
  required String hintText,
  required Icon prefixIcon,
  required bool obscureText,
  required bool enabledText,
  TextInputType textInputType = TextInputType.text,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    autofocus: false,
    enableSuggestions: false,
    autocorrect: false,
    enabled: enabledText,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    ),
    validator: validator,
  );
}

Widget customTextFieldProduct({
  required TextEditingController controller,
  required String hintText,
  required Icon? prefixIcon,
  required bool obscureText,
  TextInputType textInputType = TextInputType.text,
  int maxLines = 1,
  required String? Function(String?)? validator,
  required Function(String?)? onSaved,
}) {
  return TextFormField(
    keyboardType: textInputType,
    maxLines: maxLines,
    autofocus: false,
    enableSuggestions: false,
    autocorrect: false,
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon,
      border: UnderlineInputBorder(),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    ),
    validator: validator,
    onSaved: onSaved,
  );
}
