import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class ApprovedApplicationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> application;

  const ApprovedApplicationDetailsScreen({
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
          'Approved Application',
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
              _buildSuccessBanner(),
              SizedBox(height: 32.h),
              Text(
                MyApp.userRole == 'Worker' ? 'Business Owner Contact' : 'Employer Contact',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              _buildEmployerCard(context),
              SizedBox(height: 32.h),
              Text(
                MyApp.userRole == 'Worker' ? 'Work Details' : 'Job Details',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              _buildWorkDetails(),
              SizedBox(height: 48.h),
              Center(
                child: Text(
                  MyApp.userRole == 'Worker'
                      ? 'Show this screen to the business owner when you reach the work site.'
                      : 'Show this screen to the employer when you report for work.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Approved!',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  MyApp.userRole == 'Worker'
                      ? 'The business owner wants to hire you.'
                      : 'The employer wants to hire you.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployerCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                child: Icon(Icons.business_rounded, color: AppColors.primaryPurple, size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application['company'] ?? 'Vijay Constructions',
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      MyApp.userRole == 'Worker' ? 'Verified Business Owner' : 'Verified Employer',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: const Color(0xFF1BAB4F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildIconButton(Icons.phone_rounded, 'Call', const Color(0xFF1BAB4F), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Initiating call...'),
                      backgroundColor: AppColors.primaryPurple,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildIconButton(Icons.chat_bubble_outline_rounded, 'WhatsApp', const Color(0xFF25D366), () async {
                  final phone = application['phone'] ?? '';
                  final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
                  if (cleanPhone.isNotEmpty) {
                    final url = 'https://wa.me/$cleanPhone';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not launch WhatsApp.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone number not available.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkDetails() {
    final bool isWorker = MyApp.userRole == 'Worker';
    final location = application['location'] ?? 'Machilipatnam, Krishna';
    final salary = application['salary'] ?? '700/day';
    final duration = application['duration'] ?? 'Immediate';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.location_on_outlined, 
            isWorker ? 'Work Location' : 'Job Location', 
            location.toString()
          ),
          Divider(height: 24.h, color: Colors.black.withValues(alpha: 0.03)),
          _buildInfoRow(
            Icons.payments_outlined, 
            isWorker ? 'Daily Wage' : 'Salary', 
            salary.toString().startsWith('Rs.') ? salary.toString() : 'Rs. $salary'
          ),
          Divider(height: 24.h, color: Colors.black.withValues(alpha: 0.03)),
          _buildInfoRow(
            Icons.calendar_today_outlined, 
            isWorker ? 'Start Date' : 'Duration', 
            duration.toString()
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textGray),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
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
        ),
      ],
    );
  }
}
