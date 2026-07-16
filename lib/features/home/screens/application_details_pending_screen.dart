import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class PendingApplicationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> application;

  const PendingApplicationDetailsScreen({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
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
          'Application Details',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(),
              SizedBox(height: 32.h),
              Text(
                'Application Status',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              _buildTimeline(),
              SizedBox(height: 48.h),
              Text(
                MyApp.userRole == 'Worker' ? 'Work Summary' : 'Job Summary',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              _buildJobSummaryCard(),
              SizedBox(height: 48.h),
              _buildWithdrawButton(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.timer_outlined, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Under Review',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE65100),
                  ),
                ),
                Text(
                  MyApp.userRole == 'Worker'
                      ? 'Business owner is reviewing your profile'
                      : 'Employer is reviewing your profile',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: const Color(0xFFE65100).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineStep(
          'Application Sent',
          application['time'] ?? '2 days ago',
          true,
          true,
        ),
        _buildTimelineStep(
          'Under Review',
          'Expected response in 24 hours',
          true,
          false,
          isCurrent: true,
        ),
        _buildTimelineStep(
          MyApp.userRole == 'Worker' ? 'Business Owner Decision' : 'Employer Decision',
          'Final response from Vijay Constructions',
          false,
          false,
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, bool isCompleted, bool hasLine, {bool isCurrent = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4CAF50) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF4CAF50) : AppColors.borderGray,
                  width: 2,
                ),
              ),
              child: isCompleted 
                ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                : isCurrent 
                  ? Center(child: Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: const Color(0xFFFF9800), shape: BoxShape.circle)))
                  : null,
            ),
            if (hasLine)
              Container(
                width: 2.w,
                height: 48.h,
                color: isCompleted ? const Color(0xFF4CAF50) : AppColors.borderGray,
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isCurrent ? AppColors.textBlack : AppColors.textGray,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              if (hasLine) SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobSummaryCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildDetailRow(MyApp.userRole == 'Worker' ? 'Work Title' : 'Job Title', application['title'] ?? 'Mason Required'),
          SizedBox(height: 12.h),
          _buildDetailRow(MyApp.userRole == 'Worker' ? 'Business Owner' : 'Employer', application['company'] ?? 'Vijay Constructions'),
          SizedBox(height: 12.h),
          _buildDetailRow('Salary', application['salary'] != null ? 'Rs. ${application['salary']}' : 'Rs. 700/day'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textLightGray,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => _showWithdrawConfirmation(context),
        child: Text(
          'Withdraw Application',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD32F2F),
          ),
        ),
      ),
    );
  }

  void _showWithdrawConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text(
          'Withdraw Application?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        content: Text(
          'Are you sure you want to withdraw your application for this job? You can always apply again later.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textGray,
          ),
        ),
        actions: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to applications list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Application withdrawn successfully'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'Yes, Withdraw',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      ),
    );
  }
}
