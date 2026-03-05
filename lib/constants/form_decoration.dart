import 'package:flutter/material.dart';

import 'package:nandur_id/constants/default_font.dart';

InputDecoration formInputConstant({
  String? hintText,
  Icon? prefixIconData,
  String? labelText,
  Icon? suffixIconData,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    prefixIcon: prefixIconData,
    suffixIcon: suffixIconData,

    floatingLabelStyle: DefaultFont.bodyBold,

    errorMaxLines: 3,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: AppColor.baseGreen, width: 2),
    //   borderRadius: BorderRadius.circular(32),
    // ),
    // focusedErrorBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: AppColor.alertRed, width: 2),
    //   // borderRadius: BorderRadius.circular(32),
    // ),
  );
}
