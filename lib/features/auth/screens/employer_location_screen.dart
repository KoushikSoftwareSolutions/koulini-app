import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/location_detect_card.dart';
import 'registration_success_screen.dart';

class EmployerLocationScreen extends StatefulWidget {
  const EmployerLocationScreen({super.key});

  @override
  State<EmployerLocationScreen> createState() => _EmployerLocationScreenState();
}

class _EmployerLocationScreenState extends State<EmployerLocationScreen> {
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _mandalController = TextEditingController();
  final _villageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(),
                    SizedBox(height: 24.h),
                    Text(
                      'Business Location',
                      style: AppTextStyles.questionTitle.copyWith(fontSize: 24.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'workers near your area',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 32.h),
                    LocationDetectCard(
                      onTap: () {
                        // Trigger GPS Logic
                      },
                    ),
                    SizedBox(height: 32.h),
                    _buildLabel('State'),
                    _buildTextField(_stateController, 'e.g. Andhra Pradesh'),
                    SizedBox(height: 16.h),
                    _buildLabel('District'),
                    _buildTextField(_districtController, 'e.g. Krishna'),
                    SizedBox(height: 16.h),
                    _buildLabel('Mandal / Tahsil'),
                    _buildTextField(_mandalController, 'e.g. Machilipatnam'),
                    SizedBox(height: 16.h),
                    _buildLabel('Village / Area'),
                    _buildTextField(_villageController, 'e.g. Chilakalapudi'),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'Need Help?',
              style: GoogleFonts.poppins(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Step 2 of 2',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: 1.0,
              backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
              minHeight: 4.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                const RegistrationSuccessScreen(isEmployer: true),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Text(
          'Complete Registration',
          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
