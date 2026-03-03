import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';

class AppButtonStyles {
  static final _baseShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static const _defaultSize = Size(double.maxFinite, 56);

  //Ghost Green
  static ButtonStyle ghostGreen() {
    return ElevatedButton.styleFrom(
      fixedSize: _defaultSize,
      side: const BorderSide(color: AppColor.baseGreen),
      shape: _baseShape,
    );
  }

  //Ghost Red
  static ButtonStyle ghostRed() {
    return ElevatedButton.styleFrom(
      fixedSize: _defaultSize,
      side: const BorderSide(color: AppColor.alertRed),
      foregroundColor: AppColor.alertRed,
      shape: _baseShape,
    );
  }

  ///Solid Green
  static ButtonStyle solidGreen() {
    return ElevatedButton.styleFrom(
      fixedSize: _defaultSize,
      backgroundColor: AppColor.baseGreen,
      foregroundColor: Colors.white,
      shape: _baseShape,
    );
  }
}
