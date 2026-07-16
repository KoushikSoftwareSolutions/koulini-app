import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';


class EditBusinessScreen extends StatefulWidget {
  const EditBusinessScreen({super.key});

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _phoneController;
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final profile = authState.profile;
    _businessNameController = TextEditingController(text: profile?['businessName'] ?? 'Vijay Constructions');
    _ownerNameController = TextEditingController(text: profile?['ownerName'] ?? 'Vijay Kumar');
    _phoneController = TextEditingController(text: profile?['phone'] ?? '98480 22338');
    _profilePhotoUrl = profile?['profilePhoto'];
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Business Details',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo Section
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Stack(
                      children: [
                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            color: _profilePhotoUrl != null
                                ? Colors.transparent
                                : (() {
                                    final nameToUse = _businessNameController.text.trim().isNotEmpty
                                        ? _businessNameController.text
                                        : _ownerNameController.text;
                                    final int colorCode = nameToUse.codeUnits.fold(0, (prev, element) => prev + element);
                                    final List<Color> colors = [
                                      const Color(0xFF7C3AED),
                                      const Color(0xFFEF4444),
                                      const Color(0xFF3B82F6),
                                      const Color(0xFF10B981),
                                      const Color(0xFFF59E0B),
                                      const Color(0xFFEC4899),
                                      const Color(0xFF06B6D4),
                                    ];
                                    return colors[colorCode % colors.length];
                                  })(),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _profilePhotoUrl != null
                                    ? AppColors.primaryPurple.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                width: 2),
                            image: _profilePhotoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(_profilePhotoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profilePhotoUrl == null
                              ? Center(
                                  child: Text(
                                    (_businessNameController.text.trim().isNotEmpty
                                            ? _businessNameController.text
                                            : _ownerNameController.text)
                                        .trim()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                _buildInputLabel('Business Name'),
                _buildTextField(
                  controller: _businessNameController,
                  hint: 'Enter business name',
                  icon: Icons.business_rounded,
                ),
                SizedBox(height: 24.h),
                _buildInputLabel('Owner / Representative Name'),
                _buildTextField(
                  controller: _ownerNameController,
                  hint: 'Enter owner name',
                  icon: Icons.person_outline_rounded,
                ),
                SizedBox(height: 24.h),
                _buildInputLabel('Contact Phone Number'),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Enter phone number',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 48.h),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final authState = Provider.of<AuthState>(context, listen: false);
                      final success = await authState.updateProfile({
                        'businessName': _businessNameController.text.trim(),
                        'ownerName': _ownerNameController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        if (_profilePhotoUrl != null) 'profilePhoto': _profilePhotoUrl,
                      });
                      
                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully!')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(authState.error ?? 'Failed to update profile')),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Profile Photo',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSourceOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _simulateCameraCapture();
              },
            ),
            _buildSourceOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _simulateGallerySelection();
              },
            ),
            if (_profilePhotoUrl != null) ...[
              _buildSourceOption(
                icon: Icons.delete_rounded,
                title: 'Remove Photo',
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _profilePhotoUrl = null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Business photo removed. Save to apply.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateCameraCapture() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.pop(context);
            setState(() {
              _profilePhotoUrl = 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&auto=format&fit=crop&q=80';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo captured from camera! Save to apply.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primaryPurple),
              SizedBox(height: 16.h),
              Text(
                'Opening Camera...',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulateGallerySelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        final List<String> mockGalleryFiles = [
          'IMG_8849.png',
          'business_logo.jpg',
          'store_front.png',
          'office_building.jpg'
        ];
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Photo from Gallery',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              ...mockGalleryFiles.map((filename) => ListTile(
                leading: const Icon(Icons.image_outlined, color: AppColors.primaryPurple),
                title: Text(filename, style: GoogleFonts.poppins(fontSize: 14.sp)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {
                  setState(() {
                    _profilePhotoUrl = 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&auto=format&fit=crop&q=80';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected $filename from gallery! Save to apply.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              )).toList(),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15.sp, color: AppColors.textBlack),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textLightGray, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter this field';
          }
          return null;
        },
      ),
    );
  }
}
