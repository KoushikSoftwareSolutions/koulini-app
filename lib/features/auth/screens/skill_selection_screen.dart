import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/constants/worker_categories.dart';
import '../../../core/constants/job_categories.dart';
import 'location_selection_screen.dart';

class SkillSelectionScreen extends StatefulWidget {
  final bool isManagedProfile;
  final bool isEditing;
  final Map<String, dynamic>? initialData;

  const SkillSelectionScreen({
    super.key,
    this.isManagedProfile = false,
    this.isEditing = false,
    this.initialData,
  });

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  String? _selectedCategory;
  String? _selectedPrimarySkill;
  String? _selectedSpecialization;
  String? _selectedExperience = '1-2 Years';
  bool get _isRoleOthers => _selectedPrimarySkill == 'Others';
  bool get _isSpecializationOthers => _selectedSpecialization == 'Others';
  final TextEditingController _customSkillController = TextEditingController();
  final TextEditingController _customSpecializationController = TextEditingController();
  final TextEditingController _templeNameController = TextEditingController();

  final List<String> _experienceLevels = [
    'No Experience',
    '1-2 Years',
    '2-5 Years',
    '5-10 Years',
    '10+ Years',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.initialData != null) {
      final data = widget.initialData!;
      _selectedCategory = data['category'] as String?;
      _selectedPrimarySkill = data['primarySkill'] as String?;
      _selectedExperience = data['experienceLevel'] as String? ?? '1-2 Years';
      
      if (_selectedPrimarySkill == 'Others' && data['customSkill'] != null) {
        _customSkillController.text = data['customSkill'] as String;
      }
    }
  }

  @override
  void dispose() {
    _customSkillController.dispose();
    _customSpecializationController.dispose();
    _templeNameController.dispose();
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
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray.withValues(alpha: 0.5),
                ),
                overflow: TextOverflow.ellipsis,
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
                        child: Text(item, overflow: TextOverflow.ellipsis),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
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
    final bool isJobsFlow = userRole == UserRole.job;
    
    final availableCategories = isJobsFlow 
        ? JobCategories.categoryList 
        : WorkerCategories.categoryList;
        
    final availableSkills = _selectedCategory != null 
        ? (isJobsFlow 
            ? JobCategories.getRolesForCategory(_selectedCategory!) 
            : WorkerCategories.getOccupationsForCategory(_selectedCategory!)) 
        : <String>[];
        
    final availableSpecializations = (isJobsFlow && _selectedPrimarySkill != null && !_isRoleOthers) 
        ? JobCategories.getSpecializationsForRole(_selectedPrimarySkill!) 
        : null;

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
                      content.professionalDetailsTitle,
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      content.professionalDetailsSubtitle,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Category Dropdown
                    _buildDropdownField(
                      label: isJobsFlow ? 'Job Category' : 'Category',
                      value: _selectedCategory,
                      items: availableCategories,
                      hint: 'Select a category',
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                          _selectedPrimarySkill = null; // Reset occupation when category changes
                          _selectedSpecialization = null; // Reset specialization
                          _customSkillController.clear();
                          _customSpecializationController.clear();
                          _templeNameController.clear();
                        });
                      },
                    ),

                    // Occupation / Job Role Dropdown
                    _buildDropdownField(
                      label: isJobsFlow ? 'Job Role' : 'Occupation',
                      value: _selectedPrimarySkill,
                      items: availableSkills,
                      isEnabled: _selectedCategory != null,
                      hint: _selectedCategory == null 
                              ? 'Select a category first' 
                              : content.primaryWorkHint,
                      onChanged: (val) {
                        setState(() {
                          _selectedPrimarySkill = val;
                          _selectedSpecialization = null; // Reset specialization when role changes
                          if (val != 'Others') {
                            _customSkillController.clear();
                          }
                          _customSpecializationController.clear();
                          _templeNameController.clear();
                        });
                      },
                    ),
                    
                    // Custom Job Role / Occupation Text Field (animated)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      child: _isRoleOthers
                          ? _buildTextField(
                              label: isJobsFlow ? 'Enter your Job Role' : 'Enter your occupation',
                              controller: _customSkillController,
                              hint: isJobsFlow ? 'Example: Psychology Teacher' : 'Example: Forklift Driver',
                            )
                          : const SizedBox.shrink(),
                    ),
                    
                    // Specialization Field (Only for Jobs where applicable)
                    if (isJobsFlow && availableSpecializations != null)
                      _buildDropdownField(
                        label: 'Specialization',
                        value: _selectedSpecialization,
                        items: availableSpecializations,
                        hint: 'Select a specialization',
                        onChanged: (val) {
                          setState(() {
                            _selectedSpecialization = val;
                            if (val != 'Others') {
                              _customSpecializationController.clear();
                            }
                          });
                        },
                      ),
                      
                    // Custom Specialization Text Field (animated)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      child: (isJobsFlow && _isSpecializationOthers)
                          ? _buildTextField(
                              label: 'Enter Specialization',
                              controller: _customSpecializationController,
                              hint: 'Example: Tulu, Marwari',
                            )
                          : const SizedBox.shrink(),
                    ),
                      
                    // Temple Name (Only for Temple Priest)
                    if (isJobsFlow && _selectedPrimarySkill == 'Temple Priest')
                      _buildTextField(
                        label: 'Temple Name',
                        controller: _templeNameController,
                        hint: 'Enter Temple Name',
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
                  if (_selectedCategory == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a category'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  
                  if (_selectedPrimarySkill == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(content.noPrimarySkillError),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  
                  final customSkill = _customSkillController.text.trim();
                  if (_isRoleOthers && (customSkill.isEmpty || customSkill.length < 3)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid custom role/occupation (min 3 chars)'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  
                  if (isJobsFlow && availableSpecializations != null && _selectedSpecialization == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a specialization'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  
                  final customSpecialization = _customSpecializationController.text.trim();
                  if (isJobsFlow && _isSpecializationOthers && (customSpecialization.isEmpty || customSpecialization.length < 3)) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid custom specialization (min 3 chars)'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // Save to state
                  final authState = Provider.of<AuthState>(context, listen: false);
                  
                  if (widget.isManagedProfile) {
                    final data = Map<String, dynamic>.from(widget.initialData ?? {});
                    data['category'] = _selectedCategory;
                    data['primarySkill'] = _selectedPrimarySkill;
                    data['customSkill'] = _isRoleOthers ? customSkill : null;
                    data['experienceLevel'] = _selectedExperience;
                    
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => LocationSelectionScreen(
                          isManagedProfile: true,
                          isEditing: widget.isEditing,
                          initialData: data,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  } else {
                    authState.pendingCategory = _selectedCategory;
                    authState.pendingSkill = _selectedPrimarySkill;
                    
                    // For Specialization, save temple name if priest, else save selected dropdown value
                    authState.pendingSpecialization = (isJobsFlow && _selectedPrimarySkill == 'Temple Priest') 
                        ? _templeNameController.text.trim() 
                        : _selectedSpecialization;
                        
                    authState.pendingCustomSkill = _isRoleOthers ? customSkill : null;
                    authState.pendingCustomSpecialization = _isSpecializationOthers ? customSpecialization : null;
                    
                    authState.pendingExperienceLevel = _selectedExperience;

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
                  }
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
