import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String initial;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initial,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryPurple.withValues(alpha: 0.12) 
              : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryPurple.withValues(alpha: 0.35) 
                : AppColors.borderGray.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.primaryPurple.withValues(alpha: 0.08) 
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 16 : 8,
              offset: isSelected ? const Offset(0, 6) : const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Animated Initial Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppTextStyles.logoTitle.copyWith(
                        fontSize: 18.sp,
                        color: isSelected ? Colors.white : AppColors.textBlack,
                      ),
                      child: Text(initial),
                    ),
                  ),
                ),
                
                // Animated Radio Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4CAF50) : AppColors.textGray.withValues(alpha: 0.3),
                      width: 2.w,
                    ),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack, // Premium bouncy spring animation
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppTextStyles.logoTitle.copyWith(
                fontSize: 18.sp,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 13.sp,
                color: AppColors.textGray.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
