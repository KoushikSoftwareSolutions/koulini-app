import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import 'applicant_details_screen.dart';

class JobApplicantsScreen extends StatelessWidget {
  final Map<String, dynamic> job;
  final bool isWork;

  const JobApplicantsScreen({
    super.key,
    required this.job,
    this.isWork = false,
  });

  @override
  Widget build(BuildContext context) {
    // Mock applicants for the specific job
    final List<Map<String, dynamic>> applicants = [
      {
        'name': 'Manoj Kumar',
        'skill': 'Mason & Tile Specialist',
        'rating': '4.8',
        'experience': '2 yrs',
        'avatar': 'https://i.pravatar.cc/150?u=manoj',
      },
      {
        'name': 'Suresh V.',
        'skill': 'Painter',
        'rating': '4.5',
        'experience': '5 yrs',
        'avatar': 'https://i.pravatar.cc/150?u=suresh',
      },
      {
        'name': 'Rajesh Singh',
        'skill': 'Electrician',
        'rating': '4.9',
        'experience': '3 yrs',
        'avatar': 'https://i.pravatar.cc/150?u=rajesh',
      },
    ];

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
          'Applicants',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildJobHeader(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(24.w),
                physics: const BouncingScrollPhysics(),
                itemCount: applicants.length,
                itemBuilder: (context, index) {
                  final worker = applicants[index];
                  return _buildApplicantCard(context, worker);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      color: const Color(0xFFF9FAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'ACTIVE',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Rs. ${job['wage']}',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            job['title'],
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Machilipatnam, Krishna District',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> worker) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicantDetailsScreen(
              isWork: isWork,
              applicant: worker,
              job: job,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            PremiumImage(
              imageUrl: worker['avatar'],
              width: 56.r,
              height: 56.r,
              isAvatar: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    worker['skill'],
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLightGray, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
