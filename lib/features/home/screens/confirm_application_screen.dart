import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/services/application_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'application_success_screen.dart';
import '../../../../main.dart';

class ConfirmApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ConfirmApplicationScreen({
    super.key,
    required this.job,
  });

  @override
  State<ConfirmApplicationScreen> createState() => _ConfirmApplicationScreenState();
}

class _ConfirmApplicationScreenState extends State<ConfirmApplicationScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final profile = authState.profile;

    final String name = profile?['name'] ?? 'Worker';
    final String skill = profile?['primarySkill'] ?? profile?['customSkill'] ?? 'General Worker';
    final loc = profile?['location'] as Map<String, dynamic>?;
    final String location = loc != null
        ? '${loc['village'] ?? loc['mandal'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : 'Krishna, Andhra Pradesh';
    final String experience = profile?['experienceLevel'] ?? 'No Experience';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Confirm Application',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isSubmitting
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCondensedJobCard(),
                          SizedBox(height: 32.h),
                          Text(
                            MyApp.userRole == 'Worker'
                                ? 'Profile being shared with business owner'
                                : 'Profile being shared with employer',
                            style: AppTextStyles.questionTitle.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildProfileCard(name, skill, location, experience),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(context),
                ],
              ),
      ),
    );
  }

  Widget _buildCondensedJobCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 90.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applying for',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.job['title'] ?? 'Mason Required',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.job['company'] ?? 'Vijay Constructions'}  |  ${widget.job['location'] ?? 'Machilipatnam'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Rs.${widget.job['salary'] ?? '700/day'}',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String name, String skill, String location, String experience) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField('Name', name),
          _detailDivider(),
          _buildProfileField('Skills', skill),
          _detailDivider(),
          _buildProfileField('Location', location),
          _detailDivider(),
          _buildProfileField('Experience', experience),
          _detailDivider(),
          _buildProfileField('Phone', 'Hidden until approved'),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textGray.withValues(alpha: 0.6),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        color: AppColors.borderGray.withValues(alpha: 0.05),
        thickness: 1,
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
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
        onPressed: _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
          elevation: 6,
          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
        ),
        child: Text(
          'Submit Application',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _submitApplication() async {
    final jobId = widget.job['id']?.toString();
    if (jobId == null || jobId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Job ID.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await ApplicationService.instance.applyToJob(jobId);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ApplicationSuccessScreen(job: widget.job),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Failed to submit application.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
