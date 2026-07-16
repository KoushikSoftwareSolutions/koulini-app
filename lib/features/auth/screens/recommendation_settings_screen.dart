import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../main.dart';

class RecommendationSettingsScreen extends StatefulWidget {
  const RecommendationSettingsScreen({super.key});

  @override
  State<RecommendationSettingsScreen> createState() => _RecommendationSettingsScreenState();
}

class _RecommendationSettingsScreenState extends State<RecommendationSettingsScreen> {
  String? _selectedSkillOrBusiness;
  String? _selectedExperience;
  
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMandal;
  late TextEditingController _villageController;

  bool _isSaving = false;

  final List<String> _states = ['Andhra Pradesh', 'Telangana', 'Karnataka', 'Tamil Nadu'];
  final List<String> _districts = ['Krishna', 'Guntur', 'NTR', 'Visakhapatnam'];
  final List<String> _mandals = ['Machilipatnam', 'Pedana', 'Gudivada', 'Avanigadda'];

  final List<String> _workerSkills = [
    'AC Repair',
    'Any work',
    'Bricklayer (Mason)',
    'Carpenter',
    'Cleaning',
    'Cook/Chef',
    'Delivery Partner',
    'Driver',
    'Electrician',
    'Gardener',
    'House Help',
    'Labourer',
    'Maid',
    'Office Assistant',
    'Painter',
    'Plumber',
    'Security Guard',
    'Other'
  ];

  final List<String> _employerBusinessTypes = [
    'Construction',
    'Agriculture',
    'Retail/Shop',
    'Home Services',
    'Factory',
    'Transport',
    'Hospitality',
    'Warehouse',
    'Cleaning',
    'Event Services',
    'Other'
  ];

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
    final authState = Provider.of<AuthState>(context, listen: false);
    final profile = authState.profile;
    final isWorker = MyApp.userRole == 'Worker';

    if (isWorker) {
      _selectedSkillOrBusiness = profile?['primarySkill'] ?? 'Bricklayer (Mason)';
      _selectedExperience = profile?['experienceLevel'] ?? 'No Experience';
    } else {
      _selectedSkillOrBusiness = profile?['businessType'] ?? 'Construction';
    }

    final loc = profile?['location'] as Map<String, dynamic>?;
    _selectedState = loc?['state'] ?? 'Andhra Pradesh';
    _selectedDistrict = loc?['district'] ?? 'Krishna';
    _selectedMandal = loc?['mandal'] ?? 'Machilipatnam';
    _villageController = TextEditingController(text: loc?['village'] ?? '');
  }

  @override
  void dispose() {
    _villageController.dispose();
    super.dispose();
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

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
  }) {
    final list = List<String>.from(items);
    if (value != null && !list.contains(value)) {
      list.add(value);
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hintText,
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGray, size: 22.sp),
          style: GoogleFonts.poppins(fontSize: 15.sp, color: AppColors.textBlack),
          items: list.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _saveRecommendationSettings() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final isWorker = MyApp.userRole == 'Worker';

    setState(() {
      _isSaving = true;
    });

    final Map<String, dynamic> payload = {
      if (isWorker) 'primarySkill': _selectedSkillOrBusiness,
      if (isWorker) 'experienceLevel': _selectedExperience,
      if (!isWorker) 'businessType': _selectedSkillOrBusiness,
      'location': {
        'state': _selectedState,
        'district': _selectedDistrict,
        'mandal': _selectedMandal,
        'village': _villageController.text.trim(),
      }
    };

    final success = await authState.updateProfile(payload);

    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendations profile updated!'),
          backgroundColor: Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error ?? 'Failed to update recommendations settings.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWorker = MyApp.userRole == 'Worker';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isWorker ? 'Work Recommendations' : 'Job Recommendations',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isSaving
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Feed Recommendations',
                      style: AppTextStyles.questionTitle.copyWith(fontSize: 20.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isWorker
                          ? 'Select your target work preferences and location to find matching opportunities.'
                          : 'Select target business services and location to fetch relevant candidates.',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 13.sp),
                    ),
                    SizedBox(height: 32.h),

                    // Trade/Business Dropdown
                    _buildLabel(isWorker ? 'Primary Work / Trade' : 'Target Business Field'),
                    _buildDropdownField(
                      value: _selectedSkillOrBusiness,
                      items: isWorker ? _workerSkills : _employerBusinessTypes,
                      hintText: isWorker ? 'Select primary trade' : 'Select business field',
                      onChanged: (val) => setState(() => _selectedSkillOrBusiness = val),
                    ),
                    SizedBox(height: 20.h),

                    // Experience Dropdown (Workers only)
                    if (isWorker) ...[
                      _buildLabel('Minimum Experience'),
                      _buildDropdownField(
                        value: _selectedExperience,
                        items: _experienceLevels,
                        hintText: 'Select experience requirement',
                        onChanged: (val) => setState(() => _selectedExperience = val),
                      ),
                      SizedBox(height: 20.h),
                    ],

                    // State Dropdown
                    _buildLabel('State'),
                    _buildDropdownField(
                      value: _selectedState,
                      items: _states,
                      hintText: 'Select state',
                      onChanged: (val) => setState(() {
                        _selectedState = val;
                      }),
                    ),
                    SizedBox(height: 20.h),

                    // District Dropdown
                    _buildLabel('District'),
                    _buildDropdownField(
                      value: _selectedDistrict,
                      items: _districts,
                      hintText: 'Select district',
                      onChanged: (val) => setState(() {
                        _selectedDistrict = val;
                      }),
                    ),
                    SizedBox(height: 20.h),

                    // Mandal Dropdown
                    _buildLabel('Mandal / Tahsil'),
                    _buildDropdownField(
                      value: _selectedMandal,
                      items: _mandals,
                      hintText: 'Select mandal',
                      onChanged: (val) => setState(() {
                        _selectedMandal = val;
                      }),
                    ),
                    SizedBox(height: 20.h),

                    // Village Field
                    _buildLabel('Village / Area (Optional)'),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
                      ),
                      child: TextFormField(
                        controller: _villageController,
                        style: GoogleFonts.poppins(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: 'e.g. Chilakalapudi',
                          hintStyle: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 48.h),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _saveRecommendationSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply Recommendations Profile',
                        style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
      ),
    );
  }
}
