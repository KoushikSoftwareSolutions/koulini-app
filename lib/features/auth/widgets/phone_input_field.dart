import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textGray.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryPurple.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Country Code Prefix
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Text(
                  '+91',
                  style: AppTextStyles.languageName.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Vertical Divider (Subtle)
              Container(
                width: 1,
                height: 24.h,
                color: AppColors.borderGray.withValues(alpha: 0.5),
              ),
              // Input Field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: AppTextStyles.languageName.copyWith(
                    letterSpacing: 2.0,
                  ),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: AppTextStyles.subtitle.copyWith(
                      color: AppColors.textLightGray.withValues(alpha: 0.5),
                      letterSpacing: 1.0,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
