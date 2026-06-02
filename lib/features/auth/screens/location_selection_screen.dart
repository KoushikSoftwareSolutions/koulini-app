import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/location_detect_card.dart';
import 'registration_success_screen.dart';
import '../../../../main.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final _stateController = TextEditingController(text: 'Andhra Pradesh');
  final _districtController = TextEditingController(text: 'Krishna');
  final _mandalController = TextEditingController(text: 'Machilipatnam');
  final _villageController = TextEditingController();

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _mandalController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 4.h),
      child: Text(
        label,
        style: AppTextStyles.subtitle.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textGray.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          color: AppColors.textBlack,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textLightGray.withValues(alpha: 0.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Location',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: Text(
                'Step 3 of 3',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.h),
          child: Container(
            height: 4.h,
            width: double.infinity,
            color: const Color(0xFF4CAF50), // Fully extended green progress line
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where are you based?',
                style: AppTextStyles.questionTitle.copyWith(
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                MyApp.userRole == 'Worker'
                    ? 'Work near your area will appear first'
                    : 'Jobs near your area will appear first',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.textGray.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 32.h),

              // Auto Detection
              LocationDetectCard(
                onTap: () {
                  // Trigger GPS Logic
                },
              ),

              SizedBox(height: 24.h),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.borderGray.withValues(alpha: 0.2))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'or enter manually',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.borderGray.withValues(alpha: 0.2))),
                ],
              ),

              SizedBox(height: 24.h),

              // Manual Form
              _buildFieldLabel('State'),
              _buildTextField(controller: _stateController, hintText: 'Enter your state'),
              SizedBox(height: 14.h),

              _buildFieldLabel('District'),
              _buildTextField(controller: _districtController, hintText: 'Enter your district'),
              SizedBox(height: 14.h),

              _buildFieldLabel('Mandal'),
              _buildTextField(controller: _mandalController, hintText: 'Enter your mandal'),
              SizedBox(height: 14.h),

              _buildFieldLabel('Village/Town'),
              _buildTextField(controller: _villageController, hintText: 'Enter your village name'),

              SizedBox(height: 40.h),

              // Finish Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const RegistrationSuccessScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
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
                  'Confirm Location and Finish',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
