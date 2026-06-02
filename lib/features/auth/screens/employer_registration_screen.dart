import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'employer_location_screen.dart';

class EmployerRegistrationScreen extends StatefulWidget {
  const EmployerRegistrationScreen({super.key});

  @override
  State<EmployerRegistrationScreen> createState() => _EmployerRegistrationScreenState();
}

class _EmployerRegistrationScreenState extends State<EmployerRegistrationScreen> {
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _otherBusinessTypeController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedBusinessType;
  String? _selectedGender;

  final List<Map<String, dynamic>> _businessTypes = [
    {'name': 'Construction', 'icon': Icons.architecture_rounded},
    {'name': 'Agriculture', 'icon': Icons.agriculture_rounded},
    {'name': 'Retail/Shop', 'icon': Icons.storefront_rounded},
    {'name': 'Home Services', 'icon': Icons.home_repair_service_rounded},
    {'name': 'Factory', 'icon': Icons.factory_rounded},
    {'name': 'Transport', 'icon': Icons.local_shipping_rounded},
    {'name': 'Hospitality', 'icon': Icons.restaurant_rounded},
    {'name': 'Warehouse', 'icon': Icons.warehouse_rounded},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services_rounded},
    {'name': 'Event Services', 'icon': Icons.celebration_rounded},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _otherBusinessTypeController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
                      'Business Profile',
                      style: AppTextStyles.questionTitle.copyWith(fontSize: 24.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tell us about your business or hiring needs.',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 32.h),
                    _buildLabel('Business/Company Name'),
                    _buildTextField(_businessNameController, 'e.g. Vijay Constructions'),
                    SizedBox(height: 20.h),
                    _buildLabel('Business Owner Name'),
                    _buildTextField(_ownerNameController, 'Enter owner name'),
                    SizedBox(height: 20.h),

                    // Age and Gender row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Age'),
                              _buildTextField(_ageController, 'e.g. 35', keyboardType: TextInputType.number),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Gender'),
                              _buildGenderDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel('Phone Number'),
                    _buildTextField(_phoneController, '+91 98765 43210', keyboardType: TextInputType.phone),
                    SizedBox(height: 20.h),

                    _buildLabel('Email'),
                    _buildTextField(_emailController, 'e.g. owner@business.com', keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 32.h),

                    _buildLabel('Business Type'),
                    _buildBusinessTypeGrid(),

                    // "Other" text field shown when Other is selected
                    if (_selectedBusinessType == 'Other') ...[
                      SizedBox(height: 16.h),
                      _buildLabel('Specify your business type'),
                      _buildTextField(_otherBusinessTypeController, 'e.g. Catering, Printing, etc.'),
                    ],

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            _buildNextButton(),
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
            'Step 1 of 2',
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
              value: 0.5,
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

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Text(
            'Select',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGray, size: 22.sp),
          style: GoogleFonts.poppins(fontSize: 15.sp, color: AppColors.textBlack),
          items: _genders.map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
      ),
    );
  }

  Widget _buildBusinessTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.9,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: _businessTypes.length,
      itemBuilder: (context, index) {
        final type = _businessTypes[index];
        final isSelected = _selectedBusinessType == type['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedBusinessType = type['name']),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primaryPurple : AppColors.borderGray.withValues(alpha: 0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  type['icon'],
                  size: 20.sp,
                  color: isSelected ? AppColors.primaryPurple : AppColors.textGray,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    type['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.primaryPurple : AppColors.textBlack,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    final isEnabled = _businessNameController.text.isNotEmpty && 
                     _ownerNameController.text.isNotEmpty && 
                     _selectedBusinessType != null;

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: isEnabled ? () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const EmployerLocationScreen(),
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
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
          disabledBackgroundColor: AppColors.primaryPurple.withValues(alpha: 0.3),
        ),
        child: Text(
          'Continue',
          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
