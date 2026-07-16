import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/enums/user_role.dart';
import '../widgets/gender_selector.dart';
import 'skill_selection_screen.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() => _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'Female';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = Provider.of<AuthState>(context, listen: false);
      if (authState.pendingPhone != null && authState.pendingPhone!.isNotEmpty) {
        _phoneController.text = authState.pendingPhone!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
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
            color: readOnly ? AppColors.background : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.borderGray.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: readOnly ? AppColors.textGray : AppColors.textBlack,
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
    final authState = Provider.of<AuthState>(context, listen: false);
    final userRole = authState.pendingRole ?? UserRole.worker;
    final content = userRole.content;

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
                      content.personalDetailsSubtitle,
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

                    if (userRole == UserRole.job) ...[
                      // Jobs flow specific ordering: 5. Phone, 6. Email
                      _buildInputField(
                        label: 'Phone Number',
                        hint: 'Enter 10-digit phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        readOnly: true,
                      ),
                      _buildInputField(
                        label: 'Email',
                        hint: 'Enter email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ] else ...[
                      // Worker flow specific ordering: 5. Phone
                      _buildInputField(
                        label: 'Phone Number',
                        hint: 'Enter 10-digit phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        readOnly: true,
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
          final name = _nameController.text.trim();
          final ageStr = _ageController.text.trim();
          final age = int.tryParse(ageStr);

          if (name.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter your full name'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          if (age == null || age <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a valid age'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          // Save pending details to AuthState
          final authState = Provider.of<AuthState>(context, listen: false);
          authState.pendingName = name;
          authState.pendingAge = age;
          authState.pendingGender = _selectedGender;

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
