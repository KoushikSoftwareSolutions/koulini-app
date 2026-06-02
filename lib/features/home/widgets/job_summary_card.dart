import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class JobSummaryCard extends StatelessWidget {
  final String title;
  final String company;
  final String salary;
  final String location;
  final String duration;
  final String workers;
  final String posted;

  const JobSummaryCard({
    super.key,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.duration,
    required this.workers,
    required this.posted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light gray from design
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Center aligned for better balance
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      company,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32), // Deep green from design
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Rs. $salary',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: AppColors.borderGray.withValues(alpha: 0.1)),
          SizedBox(height: 16.h),
          _buildInfoRow(Icons.location_on_outlined, 'Location', location),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.access_time_outlined, 'Duration', duration),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.people_outline_rounded, 'Workers', workers),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.description_outlined, 'Posted', posted),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textBlack),
        SizedBox(width: 12.w),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }
}
