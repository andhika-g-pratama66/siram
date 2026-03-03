import 'package:flutter/material.dart';

InputDecoration formInputConstant({
  required String hintText,
  required Icon iconData,
}) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    prefixIcon: iconData,
  );
}
