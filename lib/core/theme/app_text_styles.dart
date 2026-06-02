import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get logoTitle => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static TextStyle get subtitle => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  static TextStyle get questionTitle => GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
    height: 1.2,
  );

  static TextStyle get languageChar => GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static TextStyle get languageName => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );
}
