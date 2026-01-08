import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppValue {
  static double superLargeSize = 60;
  static double smallTextSize = 15;
  static double largeTextSize = 30;
  static double mediumTextSize = 20;
  static TextStyle largeTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: largeTextSize,
  );
  static TextStyle mediumTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: mediumTextSize,
  );
  static TextStyle smallTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: smallTextSize,
  );
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.greyColor.withAlpha(50),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.greyColor.withAlpha(100),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.blackColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
