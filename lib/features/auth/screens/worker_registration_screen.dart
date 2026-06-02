import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/gender_selector.dart';
import 'skill_selection_screen.dart';
import '../../../../main.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() => _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _aadhaarController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textGray,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.borderGray.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textLightGray.withValues(alpha: 0.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isJobsFlow = MyApp.userRole == 'Jobs';

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
          'Personal Details',
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
                'Step 1 of 3',
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
          child: Stack(
            children: [
              Container(
                height: 4.h,
                color: AppColors.borderGray.withValues(alpha: 0.2),
              ),
              Container(
                height: 4.h,
                width: MediaQuery.of(context).size.width * 0.33,
                color: const Color(0xFF4CAF50), // Progress line (Step 1 is 1/3)
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isJobsFlow 
                          ? 'Employers use this to find the right person.'
                          : 'Business owners use this to find the right person.',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // 1. Full Name
                    _buildInputField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                    ),

                    // 2. Age
                    _buildInputField(
                      label: 'Age',
                      hint: 'Enter your age',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                    ),

                    // 3. Gender Selection
                    Text(
                      'Gender',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GenderSelector(
                      selectedGender: _selectedGender,
                      onGenderSelected: (gender) {
                        setState(() => _selectedGender = gender);
                      },
                    ),
                    SizedBox(height: 24.h),

                    if (isJobsFlow) ...[
                      // Jobs flow specific ordering: 5. Aadhaar, 6. Phone, 7. Email
                      _buildInputField(
                        label: 'Aadhaar Card',
                        hint: 'Enter 12-digit Aadhaar number',
                        controller: _aadhaarController,
                        keyboardType: TextInputType.number,
                      ),
                      _buildInputField(
                        label: 'Phone Number',
                        hint: 'Enter 10-digit phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildInputField(
                        label: 'Email',
                        hint: 'Enter email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ] else ...[
                      // Worker flow specific ordering: 5. Phone, 6. Aadhaar
                      _buildInputField(
                        label: 'Phone Number',
                        hint: 'Enter 10-digit phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildInputField(
                        label: 'Aadhaar Card',
                        hint: 'Enter 12-digit Aadhaar number',
                        controller: _aadhaarController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
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
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SkillSelectionScreen(),
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
          'Next',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
