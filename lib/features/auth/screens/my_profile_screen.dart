import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';

import 'edit_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MY Profile',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            child: Text(
              'Edit',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(authState),
            SizedBox(height: 24.h),
            _buildStatsCard(authState),
            SizedBox(height: 32.h),
            _buildSkillsSection(authState),
            SizedBox(height: 32.h),
            _buildWorkHistorySection(authState),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthState authState) {
    final profile = authState.profile;
    final String name = profile?['name'] ?? 'Worker';
    final String title = profile?['primarySkill'] ?? profile?['customSkill'] ?? 'General Worker';
    final loc = profile?['location'] as Map<String, dynamic>?;
    final String location = loc != null 
        ? '${loc['village'] ?? loc['mandal'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : 'Krishna, Andhra Pradesh';
    final avatar = (profile?['profilePhoto'] != null && profile!['profilePhoto'].toString().isNotEmpty)
        ? profile['profilePhoto'].toString()
        : 'https://i.pravatar.cc/150?u=${profile?['_id'] ?? name}';

    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          PremiumImage(
            imageUrl: avatar,
            width: 108.r,
            height: 108.r,
            isAvatar: true,
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$title Specialist',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '@ $location',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.textLightGray.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AuthState authState) {
    final stats = authState.stats;
    final applicationsStr = stats?['applications']?.toString() ?? '0';
    final hiredStr = stats?['hired']?.toString() ?? '0';
    final ratingStr = stats?['rating']?.toString() ?? '0.0';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(applicationsStr, 'Applications'),
          _buildDivider(),
          _buildStatItem(hiredStr, 'Hired'),
          _buildDivider(),
          _buildStatItem(ratingStr, 'Ratings'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.textLightGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: const Color(0xFFEEEEEE),
    );
  }

  Widget _buildSkillsSection(AuthState authState) {
    final profile = authState.profile;
    final List<String> skills = [];
    if (profile?['primarySkill'] != null) {
      skills.add(profile!['primarySkill'].toString());
    }
    if (profile?['customSkill'] != null) {
      skills.add(profile!['customSkill'].toString());
    }
    if (profile?['otherSkills'] != null) {
      skills.addAll(List<String>.from(profile!['otherSkills']));
    }
    
    if (skills.isEmpty) {
      skills.addAll(['General Labour', 'Helper']);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        skill,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWorkHistorySection(AuthState authState) {
    final historyList = authState.workHistory ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verified Work History',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          if (historyList.isEmpty)
            Text(
              'No verified work history yet.',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textLightGray,
              ),
            )
          else
            ...historyList.map((item) {
              final company = item['companyName'] ?? 'Business Owner';
              final title = item['title'] ?? 'Worker';
              final duration = item['duration'] ?? 'Contract';
              final year = item['year'] ?? '';
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildWorkHistoryItem(company, year, '$title — $duration'),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildWorkHistoryItem(String company, String year, String details) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                year,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            details,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }
}
