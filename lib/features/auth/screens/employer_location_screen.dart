import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
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

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMandal;

  final List<String> _states = ['Andhra Pradesh', 'Telangana', 'Karnataka', 'Tamil Nadu'];
  final List<String> _districts = ['Krishna', 'Guntur', 'NTR', 'Visakhapatnam'];
  final List<String> _mandals = ['Machilipatnam', 'Pedana', 'Gudivada', 'Avanigadda'];

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _mandalController.dispose();
    _villageController.dispose();
    super.dispose();
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

  Future<void> _handleFinishEmployerRegistration(BuildContext context) async {
    final state = _selectedState ?? '';
    final district = _selectedDistrict ?? '';
    final mandal = _selectedMandal ?? '';
    final village = _villageController.text.trim();

    if (state.isEmpty || district.isEmpty || mandal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill state, district, and mandal fields.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authState = Provider.of<AuthState>(context, listen: false);
    final success = await authState.registerEmployer(
      state: state,
      district: district,
      mandal: mandal,
      village: village.isNotEmpty ? village : null,
    );

    if (success) {
      if (mounted) {
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
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error ?? 'Registration failed. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _detectLocation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primaryPurple),
              SizedBox(height: 16.h),
              Text(
                'Detecting GPS Location...',
                style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Text(
                'Searching satellite signals...',
                style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColors.textLightGray),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      
      setState(() {
        _stateController.text = 'Andhra Pradesh';
        _districtController.text = 'Krishna';
        _mandalController.text = 'Machilipatnam';
        _villageController.text = 'Chilakalapudi';
        _selectedState = 'Andhra Pradesh';
        _selectedDistrict = 'Krishna';
        _selectedMandal = 'Machilipatnam';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location auto-detected: Chilakalapudi, Machilipatnam.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

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
                      onTap: _detectLocation,
                    ),
                    SizedBox(height: 32.h),
                    _buildLabel('State'),
                    _buildDropdownField(
                      value: _selectedState,
                      items: _states,
                      hintText: 'e.g. Andhra Pradesh',
                      onChanged: (val) => setState(() => _selectedState = val),
                    ),
                    SizedBox(height: 16.h),
                    _buildLabel('District'),
                    _buildDropdownField(
                      value: _selectedDistrict,
                      items: _districts,
                      hintText: 'e.g. Krishna',
                      onChanged: (val) => setState(() => _selectedDistrict = val),
                    ),
                    SizedBox(height: 16.h),
                    _buildLabel('Mandal / Tahsil'),
                    _buildDropdownField(
                      value: _selectedMandal,
                      items: _mandals,
                      hintText: 'e.g. Machilipatnam',
                      onChanged: (val) => setState(() => _selectedMandal = val),
                    ),
                    SizedBox(height: 16.h),
                    _buildLabel('Village / Area'),
                    _buildTextField(_villageController, 'e.g. Chilakalapudi'),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            _buildFinishButton(authState),
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

  Widget _buildFinishButton(AuthState authState) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : () => _handleFinishEmployerRegistration(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: authState.isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Complete Registration',
                style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
