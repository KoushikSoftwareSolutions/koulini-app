import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _dailySalaryRange = const RangeValues(300, 1000);
  RangeValues _monthlySalaryRange = const RangeValues(10000, 30000);

  final List<String> _workerCategories = ['Construction', 'Farming', 'Painting', 'Plumbing', 'Electrical', 'Driving'];
  final List<String> _jobsCategories = ['Priest', 'Teacher', 'Nurse', 'Trainer', 'Pharmacist', 'Warden'];

  final List<String> _selectedCategories = [];
  String _sortBy = 'Recently Posted';
  
  final _locationController = TextEditingController(text: 'Machilipatnam');
  String _selectedDistance = '10 km';
  final List<String> _distances = ['5 km', '10 km', '15 km', '25 km', 'Any'];

  @override
  void initState() {
    super.initState();
    // Default categories based on role
    if (MyApp.userRole == 'Worker') {
      _selectedCategories.add('Construction');
    } else {
      _selectedCategories.add('Teacher');
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isWorker ? 'Filter Work' : 'Filter Jobs',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _dailySalaryRange = const RangeValues(300, 1000);
                      _monthlySalaryRange = const RangeValues(10000, 30000);
                      _selectedCategories.clear();
                      _selectedCategories.add(isWorker ? 'Construction' : 'Teacher');
                      _locationController.text = 'Machilipatnam';
                      _selectedDistance = '10 km';
                      _sortBy = 'Recently Posted';
                    });
                  },
                  child: Text(
                    'Reset all',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Salary Ranges
            if (isWorker) ...[
              _buildSectionLabel('Daily Salary Range (Rs.)'),
              SizedBox(height: 8.h),
              RangeSlider(
                values: _dailySalaryRange,
                min: 100,
                max: 2000,
                divisions: 20,
                activeColor: AppColors.primaryPurple,
                inactiveColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                labels: RangeLabels(
                  'Rs. ${_dailySalaryRange.start.round()}',
                  'Rs. ${_dailySalaryRange.end.round()}',
                ),
                onChanged: (values) {
                  setState(() => _dailySalaryRange = values);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rs. 100', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textLightGray)),
                  Text('Rs. 2000+', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textLightGray)),
                ],
              ),
              SizedBox(height: 24.h),
            ],

            _buildSectionLabel('Monthly Salary Range (Rs.)'),
            SizedBox(height: 8.h),
            RangeSlider(
              values: _monthlySalaryRange,
              min: 5000,
              max: 50000,
              divisions: 18,
              activeColor: AppColors.primaryPurple,
              inactiveColor: AppColors.primaryPurple.withValues(alpha: 0.1),
              labels: RangeLabels(
                'Rs. ${_monthlySalaryRange.start.round()}',
                'Rs. ${_monthlySalaryRange.end.round()}',
              ),
              onChanged: (values) {
                setState(() => _monthlySalaryRange = values);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. 5000', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textLightGray)),
                Text('Rs. 50000+', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textLightGray)),
              ],
            ),
            
            SizedBox(height: 28.h),
            
            // Categories Section
            _buildSectionLabel(isWorker ? 'Work Category' : 'Job Category'),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: (isWorker ? _workerCategories : _jobsCategories)
                  .map((cat) => _buildCategoryChip(cat))
                  .toList(),
            ),
            
            SizedBox(height: 28.h),

            // Location
            _buildSectionLabel('Location'),
            SizedBox(height: 12.h),
            _buildLocationInput(),
            
            SizedBox(height: 28.h),

            // Distance
            _buildSectionLabel('Distance'),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _distances.map((dist) => _buildDistanceChip(dist)).toList(),
            ),
            
            SizedBox(height: 28.h),

            // Sort Options
            _buildSectionLabel('Sort By'),
            SizedBox(height: 12.h),
            _buildSortOption('Recently Posted'),
            _buildSortOption('Highest Salary'),
            _buildSortOption('Proximity (Nearest)'),
            
            SizedBox(height: 32.h),
            
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 4,
                shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
              ),
              child: Text(
                'Apply Filters',
                style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: _locationController,
        style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textBlack),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textLightGray, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategories.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(label);
          } else {
            _selectedCategories.add(label);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : const Color(0xFFEEEEEE),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textGray,
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceChip(String dist) {
    final isSelected = _selectedDistance == dist;
    return GestureDetector(
      onTap: () => setState(() => _selectedDistance = dist),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textGray,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label) {
    final isSelected = _sortBy == label;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = label),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.borderGray,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textBlack : AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
