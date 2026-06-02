import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../layout/employer_main_wrapper.dart';
import 'create_job_screen.dart';

class PostSuccessScreen extends StatelessWidget {
  final bool isWork;
  final String title;
  final String wage;
  final String type;

  const PostSuccessScreen({
    super.key,
    required this.isWork,
    required this.title,
    required this.wage,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final statusTitle = isWork ? 'Work Posted!' : 'Job Posted!';
    final statusSubtitle = isWork 
        ? 'Your work has been posted and is now live. Workers in your area can see and apply.'
        : 'Your job has been posted and is now live. Workers in your area can see and apply.';

    final companyLabel = isWork ? 'Business' : 'Company';
    final companyName = isWork ? 'Ravi builders.' : 'Vijay Constructions';

    final viewLabel = isWork ? 'View my work posting' : 'View my jobs';
    final postAnotherLabel = isWork ? 'Post another work' : 'Post another job';

    final shareText = isWork ? 'Share this work:' : 'Share this job:';
    final shareUrl = isWork ? 'http://sample.org/work/123' : 'http://sample.org/job/123';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            children: [
              const Spacer(),
              
              // Green circle check icon
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                statusTitle,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                statusSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),

              // Details Summary Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isNotEmpty ? title : (isWork ? 'Mason Work' : 'Mason/Construction worker'),
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Company/Business
                    _buildRow(companyLabel, companyName),
                    SizedBox(height: 12.h),

                    // Price
                    _buildRow('Price', '₹$wage/day', valueColor: const Color(0xFF2E7D32)),
                    SizedBox(height: 12.h),

                    // Type
                    _buildRow('Type', type),
                    SizedBox(height: 12.h),

                    // Share Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shareText,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.textLightGray,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: shareUrl));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard!')),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                shareUrl,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.copy_rounded,
                                size: 14.sp,
                                color: AppColors.primaryPurple,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // Primary Action: View my jobs / View my work posting
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmployerMainWrapper(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  viewLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Secondary Action: Post another job / Post another work
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateJobScreen(isWork: isWork),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56.h),
                  side: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  postAnotherLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: AppColors.textLightGray,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textBlack,
          ),
        ),
      ],
    );
  }
}
