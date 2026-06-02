import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../main.dart';

class MyStatusScreen extends StatefulWidget {
  const MyStatusScreen({super.key});

  @override
  State<MyStatusScreen> createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends State<MyStatusScreen> {
  final Set<String> _selectedWorkTypes = {'Full Time', 'Part Time'};
  String _selectedDistance = '10 km';
  
  bool _newAlerts = true;
  bool _interviewRequests = true;

  final List<String> _workTypes = ['Full Time', 'Part Time', 'Daily Wage', 'Contract'];
  final List<String> _distances = ['5 km', '10 km', '15 km', '25 km', 'Any'];

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';

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
          'My Status',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    
                    // Work Type Section
                    _buildSectionHeader('Work Type'),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: _workTypes.map((type) {
                        final isSelected = _selectedWorkTypes.contains(type);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedWorkTypes.remove(type);
                              } else {
                                _selectedWorkTypes.add(type);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryPurple : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryPurple : const Color(0xFFEEEEEE),
                              ),
                            ),
                            child: Text(
                              type,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    SizedBox(height: 36.h),
                    
                    // Max Travel Distance Section
                    _buildSectionHeader('Max Travel Distance'),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: _distances.map((dist) {
                        final isSelected = _selectedDistance == dist;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDistance = dist),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryPurple : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryPurple : const Color(0xFFEEEEEE),
                              ),
                            ),
                            child: Text(
                              dist,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    SizedBox(height: 36.h),
                    
                    // Notification Preferences Section
                    _buildSectionHeader('Notification Preferences'),
                    SizedBox(height: 16.h),
                    
                    _buildSwitchTile(
                      title: isWorker ? 'New work alerts' : 'New job alerts',
                      value: _newAlerts,
                      onChanged: (val) => setState(() => _newAlerts = val),
                    ),
                    
                    if (!isWorker) ...[
                      SizedBox(height: 12.h),
                      _buildSwitchTile(
                        title: 'Interview requests',
                        value: _interviewRequests,
                        onChanged: (val) => setState(() => _interviewRequests = val),
                      ),
                    ],
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            
            // Save Button Footer
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status updated successfully!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 0,
                ),
                child: Text(
                  'Save Status',
                  style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.primaryPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
