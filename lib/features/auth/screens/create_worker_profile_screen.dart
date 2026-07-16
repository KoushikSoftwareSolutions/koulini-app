import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import 'skill_selection_screen.dart';

class CreateWorkerProfileScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? initialData;

  const CreateWorkerProfileScreen({
    super.key,
    this.isEditing = false,
    this.initialData,
  });

  @override
  State<CreateWorkerProfileScreen> createState() => _CreateWorkerProfileScreenState();
}

class _CreateWorkerProfileScreenState extends State<CreateWorkerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _customRelationshipController = TextEditingController();

  String _gender = 'Male';
  String _relationship = 'Father';
  
  final List<String> _relationshipOptions = [
    'Father', 'Mother', 'Brother', 'Sister', 'Husband', 'Wife', 'Son', 'Daughter', 
    'Relative', 'Friend', 'Neighbour', 'Employee', 'Contractor', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data['name'] ?? '';
      _ageController.text = (data['age'] ?? '').toString();
      _phoneController.text = data['phone'] ?? '';
      _emergencyContactController.text = data['emergencyContact'] ?? '';
      _gender = data['gender'] ?? 'Male';
      
      final rel = data['relationship'] ?? 'Father';
      if (_relationshipOptions.contains(rel)) {
        _relationship = rel;
      } else {
        _relationship = 'Other';
        _customRelationshipController.text = rel;
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_relationship == 'Other' && _customRelationshipController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify the relationship')),
      );
      return;
    }

    final data = Map<String, dynamic>.from(widget.initialData ?? {});
    data['name'] = _nameController.text.trim();
    data['age'] = int.tryParse(_ageController.text.trim()) ?? 18;
    data['gender'] = _gender;
    data['phone'] = _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();
    data['emergencyContact'] = _emergencyContactController.text.trim().isEmpty ? null : _emergencyContactController.text.trim();
    data['relationship'] = _relationship == 'Other' ? _customRelationshipController.text.trim() : _relationship;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SkillSelectionScreen(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: Text(
          widget.isEditing ? 'Edit Worker Profile' : 'Add Worker Profile',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
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
                Text(
                  'Profile Details',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Full Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration('Age'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: _inputDecoration('Gender'),
                        items: ['Male', 'Female', 'Other']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: _relationship,
                  decoration: _inputDecoration('Relationship'),
                  items: _relationshipOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _relationship = v!),
                ),
                if (_relationship == 'Other') ...[
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _customRelationshipController,
                    decoration: _inputDecoration('Specify Relationship'),
                    validator: (v) => _relationship == 'Other' && v!.isEmpty ? 'Required' : null,
                  ),
                ],
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Mobile Number (Optional)'),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Emergency Contact Number (Optional)'),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primaryPurple),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
    );
  }
}
