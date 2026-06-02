import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'location_selection_screen.dart';
import '../../../../main.dart';

class SkillSelectionScreen extends StatefulWidget {
  const SkillSelectionScreen({super.key});

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  String? _selectedPrimarySkill;
  String? _selectedExperience = '1-2 Years';
  bool _customSkillChecked = false;
  final TextEditingController _customSkillController = TextEditingController();

  final List<String> _experienceLevels = [
    'No Experience',
    '1-2 Years',
    '2-5 Years',
    '5-10 Years',
    '10+ Years',
  ];

  // Workers primary skills (from PDF/code plus more)
  final List<String> _workerSkills = [
    'Mason',
    'Carpenter',
    'Painter',
    'Labour Helper',
    'Plumber',
    'Electrician',
    'AC Repair',
    'Welder',
    'Cook',
    'Driver',
    'Security Guard',
    'Cleaner',
    'Tailor',
    'Gardener',
    'Maid',
    'Mechanic',
    'Plasterer',
  ];

  // Jobs primary skills (bounded: teacher, priest, trainer, nurse, pharmacist, warden)
  final List<String> _jobSkills = [
    'teacher',
    'priest',
    'trainer',
    'nurse',
    'pharmacist',
    'warden',
  ];

  @override
  void dispose() {
    _customSkillController.dispose();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
    bool isEnabled = true,
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.borderGray.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray.withValues(alpha: 0.5),
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textBlack),
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: isEnabled 
                  ? items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList()
                  : null,
              onChanged: isEnabled ? onChanged : null,
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
    final availableSkills = isJobsFlow ? _jobSkills : _workerSkills;

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
          'Professional Info',
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
                'Step 2 of 3',
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
                width: MediaQuery.of(context).size.width * 0.66,
                color: const Color(0xFF4CAF50), // Progress line (Step 2 is 2/3)
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
                      'Primary Skill & Experience',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isJobsFlow
                          ? 'Select the job category you specialize in.'
                          : 'Select your primary trade and experience level.',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Primary Skill Dropdown
                    _buildDropdownField(
                      label: 'Primary Skill',
                      value: _selectedPrimarySkill,
                      items: availableSkills,
                      isEnabled: !_customSkillChecked,
                      hint: _customSkillChecked ? 'Custom skill selected below' : 'Select your primary skill',
                      onChanged: (val) {
                        setState(() {
                          _selectedPrimarySkill = val;
                        });
                      },
                    ),

                    // Years of Experience Dropdown
                    _buildDropdownField(
                      label: 'Years of Experience',
                      value: _selectedExperience,
                      items: _experienceLevels,
                      hint: 'Select experience level',
                      onChanged: (val) {
                        setState(() {
                          _selectedExperience = val;
                        });
                      },
                    ),

                    // unlisted skill section for jobs flow only
                    if (isJobsFlow) ...[
                      Row(
                        children: [
                          Checkbox(
                            value: _customSkillChecked,
                            activeColor: AppColors.primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _customSkillChecked = val ?? false;
                                if (_customSkillChecked) {
                                  _selectedPrimarySkill = null; // Deselect primary dropdown
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              "My skill is not listed above",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        child: _customSkillChecked
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Review your job skill',
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
                                      controller: _customSkillController,
                                      maxLines: 2,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textBlack,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Type your job skill here (e.g. Priest)',
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 13.sp,
                                          color: AppColors.textLightGray.withValues(alpha: 0.5),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "Note: If you don't have the primary skills given by the app, we will add in the future. This review will be visible only to the Admin Panel. If majority users ask for the same job, it will be added officially.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      color: AppColors.textLightGray,
                                      height: 1.35,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Solid Section for Button
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
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const LocationSelectionScreen(),
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
            ),
          ],
        ),
      ),
    );
  }
}
