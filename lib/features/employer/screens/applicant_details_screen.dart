import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';

class ApplicantDetailsScreen extends StatefulWidget {
  final bool isWork;
  final Map<String, dynamic> applicant;
  final Map<String, dynamic> job;

  const ApplicantDetailsScreen({
    super.key,
    required this.isWork,
    required this.applicant,
    required this.job,
  });

  @override
  State<ApplicantDetailsScreen> createState() => _ApplicantDetailsScreenState();
}

class _ApplicantDetailsScreenState extends State<ApplicantDetailsScreen> {
  String _status = 'Pending';

  @override
  Widget build(BuildContext context) {
    final detailHeader = widget.isWork ? 'Work Details' : 'Job Details';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Applicant',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
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
                    // Top profile card row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PremiumImage(
                          imageUrl: widget.applicant['avatar'] ?? 'https://i.pravatar.cc/150?u=manoj',
                          width: 64.r,
                          height: 64.r,
                          isAvatar: true,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.applicant['name'] ?? 'Suresh Babu',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '32, Male . Bodhan',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.textLightGray,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Applied 12 Mar',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.textLightGray.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _status,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: _status == 'Approved' 
                                ? const Color(0xFF2E7D32) 
                                : (_status == 'Rejected' ? const Color(0xFFC62828) : const Color(0xFFFF9800)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // "Applied for" section
                    Text(
                      'Applied for',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLightGray,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.job['title'] ?? 'Mason / Construction Worker',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '₹${widget.job['wage'] ?? "600/day"} · Full-time · Bodhan',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: AppColors.textLightGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Section title (Work Details / Job Details)
                    Text(
                      detailHeader,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Details Rows
                    _buildDetailRow('Skills', widget.applicant['skill'] ?? 'Mason, Plastering, Brick Work'),
                    _buildDetailRow('Experience', widget.applicant['experience'] ?? '3+ years'),
                    _buildDetailRow('Availability', 'Immediate'),
                    _buildDetailRow('Applied on', '12 Mar 2026'),
                    _buildDetailRow(
                      'Phone', 
                      _status == 'Approved' ? '+91 9876543210' : 'Hidden until approved',
                      valueColor: _status == 'Approved' ? AppColors.textBlack : AppColors.textLightGray,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            if (_status == 'Pending')
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
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _status = 'Rejected');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Application Rejected'),
                              backgroundColor: Color(0xFFC62828),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.h),
                          side: const BorderSide(color: Color(0xFFC62828)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          '✕ Reject',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFC62828),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _status = 'Approved');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Application Approved! Contact number revealed.'),
                              backgroundColor: Color(0xFF2E7D32),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '✓ Approve',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
