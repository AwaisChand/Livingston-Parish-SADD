import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AppColors/app_colors.dart';
import '../Config/size_config.dart';

class AppTextStyle {
  ///Auth text style
  static TextStyle k30Bold700TextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: AppColors.whiteColor,
      fontSize: getFont(30),
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle k18Bold400TextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w400,
      fontSize: getFont(18),
    ),
  );

  static TextStyle k15Bold400TextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: AppColors.darkGray,
      fontSize: getFont(15),
      fontWeight: FontWeight.w400,
    ),
  );

  // static TextStyle userInfoNormalTextStyle = GoogleFonts.montserrat(
  //   color: AppColors.blackColor,
  //   fontSize: getFont(20),
  //   fontWeight: FontWeight.w400,
  // );

  static TextStyle k25Bold700TextStyle = GoogleFonts.montserrat(
    color: AppColors.blackColor,
    fontSize: getFont(25),
    fontWeight: FontWeight.w700,
  );

  static TextStyle k20Bold700TextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: AppColors.blackColor,
      fontSize: getFont(20),
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle k12Bold700TextStyle = GoogleFonts.montserrat(
    color: AppColors.whiteColor,
    fontSize: getFont(12),
    fontWeight: FontWeight.w700,
  );

  static TextStyle k12Bold400TextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
    ),
  );
}
