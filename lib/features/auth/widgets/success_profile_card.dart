import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';

class SuccessProfileCard extends StatelessWidget {
  const SuccessProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final profile = authState.profile;

    final isEmployer = authState.role == 'Employer';

    // Extract dynamic fields
    final String name = isEmployer
        ? (profile?['businessName'] ?? profile?['ownerName'] ?? 'Business Name')
        : (profile?['name'] ?? 'Worker Name');

    final String subtitle = isEmployer
        ? (profile?['businessType'] ?? 'Employer Profile')
        : (profile?['primarySkill'] ?? profile?['customSkill'] ?? 'General Worker');

    final loc = profile?['location'] as Map<String, dynamic>?;
    final String location = loc != null
        ? '${loc['village'] ?? loc['mandal'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : 'Krishna, Andhra Pradesh';

    final int age = isEmployer
        ? (profile?['ownerAge'] ?? 30)
        : (profile?['age'] ?? 25);

    final String phone = profile?['phone'] ?? authState.phone ?? authState.pendingPhone ?? '+91 XXXXX XXXXX';

    // Initials for avatar
    String initials = 'MK';
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: isEmployer ? AppColors.primaryPurple : const Color(0xFF1B5E20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name and info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                    Text(
                      location,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textLightGray.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'Age: $age',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLightGray.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          '  •  ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textLightGray.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          phone,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLightGray.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Progress Section
          Divider(color: AppColors.borderGray.withValues(alpha: 0.1)),
          SizedBox(height: 12.h),
          Text(
            'Profile 100% complete',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4CAF50),
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: 1.0,
              minHeight: 8.h,
              backgroundColor: AppColors.borderGray.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }
}
