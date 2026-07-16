import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class WorkerHelpFaqScreen extends StatelessWidget {
  const WorkerHelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';

    final faqs = [
      {
        'category': isWorker ? 'Finding Work' : 'Finding Jobs',
        'questions': [
          {
            'q': isWorker ? 'How do I apply for work?' : 'How do I apply for a job?',
            'a': isWorker 
                ? 'Tap on any work card and press the Apply Now button. Your profile will be shared with the business owner for review.'
                : 'Tap on any job card and press the Apply Now button. Your profile will be shared with the employer for review.'
          },
          {
            'q': isWorker ? 'How will I be Paid?' : 'How will I be paid?',
            'a': isWorker 
                ? 'Payment is arranged directly with the business owner. Koulini helps track the agreed daily rate to prevent disputes.'
                : 'Salary/payment is arranged directly with the employer. Koulini helps track the agreed rate to prevent disputes.'
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
            'q': isWorker ? 'How do I add my previous work?' : 'How do I add my previous job experience?',
            'a': isWorker 
                ? 'Go to Edit Profile and scroll to the "Work Gallery" section. You can add titles, descriptions, and photos of your best work to attract more business owners.'
                : 'Go to Edit Profile and scroll to the "Job History" section. You can add company names, years, and descriptions of your previous roles to attract more employers.'
          },
        ]
      },
      {
        'category': 'Support',
        'questions': [
          {
            'q': isWorker ? 'What if the business owner doesn\'t respond?' : 'What if the employer doesn\'t respond?',
            'a': isWorker 
                ? 'Contact our support team after 48 hours. We will follow up with the business owner on your behalf.'
                : 'Contact our support team after 48 hours. We will follow up with the employer on your behalf.'
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
