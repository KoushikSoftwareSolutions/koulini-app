import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final genders = ['Female', 'Male', 'Other'];

    return Row(
      children: genders.map((gender) {
        final isSelected = selectedGender == gender;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: gender == 'Other' ? 0 : 12.w,
            ),
            child: GestureDetector(
              onTap: () => onGenderSelected(gender),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.primaryPurple 
                        : AppColors.borderGray.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    gender,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
