import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import '../../../core/services/application_service.dart';

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
  late String _status;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.applicant['status'] ?? 'Pending';
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);

    final appId = widget.applicant['_id'] as String? ?? '';
    final result = await ApplicationService.instance.updateApplicationStatus(
      applicationId: appId,
      status: newStatus,
    );

    setState(() => _isUpdating = false);

    if (result.success) {
      setState(() {
        _status = newStatus;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus == 'Approved' 
                ? 'Application Approved! Contact number revealed.' 
                : 'Application Rejected.'),
            backgroundColor: newStatus == 'Approved' ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Failed to update status. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailHeader = widget.isWork ? 'Work Details' : 'Job Details';
    final worker = widget.applicant['worker'] as Map<String, dynamic>? ?? {};
    final name = worker['name'] ?? 'Unknown';
    final skill = worker['primarySkill'] ?? 'General Labour';
    final age = worker['age'] ?? 'N/A';
    final gender = worker['gender'] ?? 'N/A';
    final experience = worker['experienceLevel'] ?? 'No Experience';
    final rating = worker['rating']?.toString() ?? '0.0';
    final photo = worker['profilePhoto'] as String? ?? 'https://i.pravatar.cc/150?u=$name';

    // Formatting date
    String formattedAppliedDate = 'Recently';
    try {
      final applied = widget.applicant['appliedAt'] as String;
      formattedAppliedDate = DateFormat('dd MMM yyyy').format(DateTime.parse(applied));
    } catch (_) {}

    // Formatting location
    String locText = 'Bodhan';
    final loc = worker['location'] as Map?;
    if (loc != null) {
      locText = loc['mandal'] ?? loc['district'] ?? 'Bodhan';
    }

    final jobLoc = widget.job['location'] as Map?;
    final jobMandal = jobLoc?['mandal'] ?? 'Bodhan';
    final wage = widget.job['salary'] ?? widget.job['wage'] ?? 'N/A';

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
                          imageUrl: photo,
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
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '$age, $gender · $locText',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.textLightGray,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Applied $formattedAppliedDate',
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
                            widget.job['title'] ?? 'Job Title',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '₹$wage · ${widget.job['jobType'] ?? "Full"} · $jobMandal',
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
                    _buildDetailRow('Skills', skill),
                    _buildDetailRow('Experience', experience),
                    _buildDetailRow('Rating', '$rating ★'),
                    _buildDetailRow('Applied on', formattedAppliedDate),
                    _buildDetailRow(
                      'Phone', 
                      _status == 'Approved' ? (worker['phone'] ?? 'N/A') : 'Hidden until approved',
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
                child: _isUpdating
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryPurple),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _updateStatus('Rejected'),
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
                              onPressed: () => _updateStatus('Approved'),
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
