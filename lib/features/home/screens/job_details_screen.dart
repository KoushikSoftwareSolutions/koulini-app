import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/job_summary_card.dart';
import 'confirm_application_screen.dart';
import '../../../../main.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';
    final bool isExpired = job['isExpired'] == true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isWorker ? 'Work Details' : 'Job Details',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isExpired) ...[
                      _buildExpiredHeader(isWorker),
                      SizedBox(height: 24.h),
                      _buildExpiredWarningBanner(isWorker),
                      SizedBox(height: 32.h),
                      _buildSimilarJobsSection(context, isWorker),
                    ] else ...[
                      JobSummaryCard(
                        title: job['title'] ?? 'Mason Required',
                        company: job['company'] ?? 'Vijay Constructions',
                        salary: job['salary'] ?? '700/day',
                        location: job['location'] ?? 'Machilipatnam, Krishna',
                        duration: job['duration'] ?? '15 days (Contract)',
                        workers: job['workers'] ?? '3 workers needed',
                        posted: job['posted'] ?? 'Today, 10:30 AM',
                      ),
                      SizedBox(height: 32.h),
                      
                      Text(
                        'Job Description',
                        style: AppTextStyles.questionTitle.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        job['description'] ?? 'No description provided for this position.',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppColors.textGray.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      Text(
                        'Requirements',
                        style: AppTextStyles.questionTitle.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: 16.h),
                      if (job['requirements'] != null && (job['requirements'] as List).isNotEmpty)
                        ... (job['requirements'] as List).map((req) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildRequirementRow(req.toString()),
                        )).toList()
                      else ...[
                        _buildRequirementRow(isWorker ? 'Prior experience preferred' : 'Relevant qualifications required'),
                        SizedBox(height: 12.h),
                        _buildRequirementRow('Available immediately'),
                        SizedBox(height: 12.h),
                        _buildRequirementRow('Reliable and dedicated'),
                      ],
                      
                      SizedBox(height: 32.h),
                    ],
                  ],
                ),
              ),
            ),
            
            if (!isExpired)
              // Apply Now Button Footer
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmApplicationScreen(job: job),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
                  ),
                  child: Text(
                    'Apply Now',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredHeader(bool isWorker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // EXPIRED Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF44336),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'EXPIRED',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Title and salary row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'] ?? 'Electrician Helper',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    job['company'] ?? 'Raj Construction Co.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.textGray,
                    ),
                  ),
                  Text(
                    job['location'] ?? 'Andheri East, Mumbai',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Posted: Feb 15 · Expired: Feb 28, 2024',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.textLightGray.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Rs. ${job['salary'] ?? '650/day'}',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpiredWarningBanner(bool isWorker) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isWorker
                ? 'This work is no longer accepting applications.'
                : 'This job is no longer accepting applications.',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            isWorker
                ? 'The business owner has not renewed this posting.'
                : 'The employer has not renewed this posting.',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarJobsSection(BuildContext context, bool isWorker) {
    final similarJobs = [
      {
        'title': 'Mason Helper',
        'company': 'Raj Infra',
        'salary': '580/day',
        'avatar': Icons.engineering_rounded,
      },
      {
        'title': 'Plumber Asst.',
        'company': 'HomeFixit',
        'salary': '580/day',
        'avatar': Icons.plumbing_rounded,
      },
      {
        'title': 'Electrician',
        'company': 'PowerGrid Co.',
        'salary': '580/day',
        'avatar': Icons.electrical_services_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isWorker ? 'Similar Work Near You' : 'Similar Jobs Near You',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 16.h),
        ...similarJobs.map((similarJob) => _buildSimilarJobItem(context, similarJob)),
      ],
    );
  }

  Widget _buildSimilarJobItem(BuildContext context, Map<String, dynamic> similarJob) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            child: Icon(
              similarJob['avatar'] as IconData,
              color: AppColors.primaryPurple,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  similarJob['title'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  similarJob['company'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${similarJob['salary']}',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmApplicationScreen(job: similarJob),
                    ),
                  );
                },
                child: Text(
                  'Apply',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50), // Green from design
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.check, size: 16.sp, color: Colors.white),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }
}
