import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'category': 'Finding Jobs',
        'questions': [
          {
            'q': 'How do I apply for a job?',
            'a': 'Tap on any job card and press the Apply Now button. Your profile will be shared with the employer for review.'
          },
          {
            'q': 'How will I be Paid?',
            'a': 'Payment is arranged directly with the employer. Koulini helps track the agreed daily rate to prevent disputes.'
          },
        ]
      },
      {
        'category': 'Profile & Skills',
        'questions': [
          {
            'q': 'Can I change my skills?',
            'a': 'Yes! Go to Profile > Edit Profile > Skills to update your skill categories and add new ones.'
          },
          {
            'q': 'How do I update my job history?',
            'a': 'Go to Edit Profile and scroll to the "Job History" section. You can add titles, descriptions, and details of your past jobs to attract more employers.'
          },
        ]
      },
      {
        'category': 'Support',
        'questions': [
          {
            'q': 'What if employer doesn\'t respond?',
            'a': 'Contact our support team after 48 hours. We will follow up with the employer on your behalf.'
          },
          {
            'q': 'How to delete my account?',
            'a': 'Go to Settings > Privacy > Delete Account. Please note this action is permanent.'
          },
        ]
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & FAQ',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: faqs.map((cat) => _buildFaqCategory(cat)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCategory(Map<String, dynamic> cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cat['category'],
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
        SizedBox(height: 16.h),
        ... (cat['questions'] as List).map((faq) => _buildFaqItem(faq['q'], faq['a'])).toList(),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        iconColor: AppColors.primaryPurple,
        collapsedIconColor: AppColors.textLightGray,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
