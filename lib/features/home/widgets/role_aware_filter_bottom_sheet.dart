import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../main.dart';
import '../../../../core/services/filter_storage_service.dart';
import '../../../../core/models/worker_filter_model.dart';
import '../../../../core/models/job_filter_model.dart';
import 'filters/worker_filter_config.dart';
import 'filters/job_filter_config.dart';

class RoleAwareFilterBottomSheet extends StatefulWidget {
  const RoleAwareFilterBottomSheet({super.key});

  @override
  State<RoleAwareFilterBottomSheet> createState() => _RoleAwareFilterBottomSheetState();
}

class _RoleAwareFilterBottomSheetState extends State<RoleAwareFilterBottomSheet> {
  final bool _isWorker = MyApp.userRole == 'Worker';
  bool _isLoading = true;

  WorkerFilterModel? _workerFilter;
  JobFilterModel? _jobFilter;

  // Temporary UI state controllers
  final TextEditingController _customFieldController = TextEditingController();
  final TextEditingController _locationStateController = TextEditingController();
  final TextEditingController _locationDistrictController = TextEditingController();
  final TextEditingController _locationMandalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    if (_isWorker) {
      _workerFilter = await FilterStorageService.instance.getWorkerFilter();
      if (_workerFilter?.customOccupation != null) {
        _customFieldController.text = _workerFilter!.customOccupation!;
      }
      if (_workerFilter?.location != null) {
        _locationStateController.text = _workerFilter!.location!['state'] ?? '';
        _locationDistrictController.text = _workerFilter!.location!['district'] ?? '';
        _locationMandalController.text = _workerFilter!.location!['mandal'] ?? '';
      }
    } else {
      _jobFilter = await FilterStorageService.instance.getJobFilter();
      if (_jobFilter?.customJobRole != null || _jobFilter?.customSpecialization != null) {
        _customFieldController.text = _jobFilter!.customJobRole ?? _jobFilter!.customSpecialization ?? '';
      }
      if (_jobFilter?.location != null) {
        _locationStateController.text = _jobFilter!.location!['state'] ?? '';
        _locationDistrictController.text = _jobFilter!.location!['district'] ?? '';
        _locationMandalController.text = _jobFilter!.location!['mandal'] ?? '';
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _customFieldController.dispose();
    _locationStateController.dispose();
    _locationDistrictController.dispose();
    _locationMandalController.dispose();
    super.dispose();
  }

  Future<void> _resetFilters() async {
    if (_isWorker) {
      await FilterStorageService.instance.clearWorkerFilter();
    } else {
      await FilterStorageService.instance.clearJobFilter();
    }
    _customFieldController.clear();
    _locationStateController.clear();
    _locationDistrictController.clear();
    _locationMandalController.clear();
    await _loadFilters(); // Reload fresh defaults
  }

  Future<void> _applyFilters() async {
    // Update location map
    Map<String, String>? locationMap;
    if (_locationStateController.text.isNotEmpty || _locationDistrictController.text.isNotEmpty || _locationMandalController.text.isNotEmpty) {
      locationMap = {
        'state': _locationStateController.text,
        'district': _locationDistrictController.text,
        'mandal': _locationMandalController.text,
      };
    }

    if (_isWorker && _workerFilter != null) {
      _workerFilter!.location = locationMap;
      if (_workerFilter!.occupation == 'Others') {
        _workerFilter!.customOccupation = _customFieldController.text;
      } else {
        _workerFilter!.customOccupation = null;
      }
      await FilterStorageService.instance.saveWorkerFilter(_workerFilter!);
      if (mounted) Navigator.pop(context, _workerFilter);
    } else if (!_isWorker && _jobFilter != null) {
      _jobFilter!.location = locationMap;
      if (_jobFilter!.jobRole == 'Others') {
        _jobFilter!.customJobRole = _customFieldController.text;
      } else {
        _jobFilter!.customJobRole = null;
      }
      if (_jobFilter!.specialization == 'Others') {
         _jobFilter!.customSpecialization = _customFieldController.text;
      } else {
         _jobFilter!.customSpecialization = null;
      }
      await FilterStorageService.instance.saveJobFilter(_jobFilter!);
      if (mounted) Navigator.pop(context, _jobFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
                  _isWorker ? WorkerFilterConfiguration.title : JobFilterConfiguration.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
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

            if (_isWorker) _buildWorkerFilters() else _buildJobFilters(),

            SizedBox(height: 32.h),

            ElevatedButton(
              onPressed: _applyFilters,
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
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerFilters() {
    final filter = _workerFilter!;
    final validOccupations = filter.category != null ? WorkerFilterConfiguration.getOccupations(filter.category!) : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Expected Monthly Income (Rs.)'),
        SizedBox(height: 8.h),
        RangeSlider(
          values: RangeValues(filter.minIncome, filter.maxIncome),
          min: WorkerFilterConfiguration.minIncome,
          max: WorkerFilterConfiguration.maxIncome,
          divisions: 45,
          activeColor: AppColors.primaryPurple,
          inactiveColor: AppColors.primaryPurple.withValues(alpha: 0.1),
          labels: RangeLabels('Rs. ${filter.minIncome.round()}', 'Rs. ${filter.maxIncome.round()}'),
          onChanged: (values) {
            setState(() {
              filter.minIncome = values.start;
              filter.maxIncome = values.end;
            });
          },
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Worker Category'),
        SizedBox(height: 8.h),
        _buildDropdown(
          value: filter.category,
          items: WorkerFilterConfiguration.categories,
          hint: 'Select Category',
          onChanged: (val) {
            setState(() {
              filter.category = val;
              filter.occupation = null; // Reset occupation
            });
          },
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Occupation'),
        SizedBox(height: 8.h),
        _buildDropdown(
          value: filter.occupation,
          items: validOccupations,
          hint: 'Select Occupation',
          disabled: filter.category == null,
          onChanged: (val) {
            setState(() {
              filter.occupation = val;
            });
          },
        ),
        if (filter.occupation == 'Others') ...[
          SizedBox(height: 12.h),
          _buildTextField('Enter custom occupation', _customFieldController),
        ],
        SizedBox(height: 24.h),

        _buildSectionLabel('Experience'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: WorkerFilterConfiguration.experienceLevels
              .map((exp) => _buildChip(
                    label: exp,
                    isSelected: filter.experience == exp,
                    onTap: () => setState(() => filter.experience = exp),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Work Type'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: WorkerFilterConfiguration.workTypes
              .map((type) => _buildChip(
                    label: type,
                    isSelected: filter.workType == type,
                    onTap: () => setState(() => filter.workType = type),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Availability'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: WorkerFilterConfiguration.availabilityOptions
              .map((type) => _buildChip(
                    label: type,
                    isSelected: filter.availability == type,
                    onTap: () => setState(() => filter.availability = type),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildLocationAndDistance(filter.distance, (val) => setState(() => filter.distance = val), WorkerFilterConfiguration.distances),

        SizedBox(height: 24.h),
        _buildSortOptions(filter.sortBy, (val) => setState(() => filter.sortBy = val), WorkerFilterConfiguration.sortOptions),
      ],
    );
  }

  Widget _buildJobFilters() {
    final filter = _jobFilter!;
    final validRoles = filter.jobCategory != null ? JobFilterConfiguration.getJobRoles(filter.jobCategory!) : <String>[];
    final validSpecs = filter.jobRole != null ? JobFilterConfiguration.getSpecializations(filter.jobRole!) : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Expected Monthly Salary (Rs.)'),
        SizedBox(height: 8.h),
        RangeSlider(
          values: RangeValues(filter.minSalary, filter.maxSalary),
          min: JobFilterConfiguration.minSalary,
          max: JobFilterConfiguration.maxSalary,
          divisions: 195,
          activeColor: AppColors.primaryPurple,
          inactiveColor: AppColors.primaryPurple.withValues(alpha: 0.1),
          labels: RangeLabels('Rs. ${filter.minSalary.round()}', 'Rs. ${filter.maxSalary.round()}'),
          onChanged: (values) {
            setState(() {
              filter.minSalary = values.start;
              filter.maxSalary = values.end;
            });
          },
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Job Category'),
        SizedBox(height: 8.h),
        _buildDropdown(
          value: filter.jobCategory,
          items: JobFilterConfiguration.categories,
          hint: 'Select Job Category',
          onChanged: (val) {
            setState(() {
              filter.jobCategory = val;
              filter.jobRole = null;
              filter.specialization = null;
            });
          },
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Job Role'),
        SizedBox(height: 8.h),
        _buildDropdown(
          value: filter.jobRole,
          items: validRoles,
          hint: 'Select Job Role',
          disabled: filter.jobCategory == null,
          onChanged: (val) {
            setState(() {
              filter.jobRole = val;
              filter.specialization = null;
            });
          },
        ),
        if (filter.jobRole == 'Others') ...[
          SizedBox(height: 12.h),
          _buildTextField('Enter custom job role', _customFieldController),
        ],
        SizedBox(height: 24.h),

        if (validSpecs.isNotEmpty || filter.specialization == 'Others') ...[
          _buildSectionLabel('Specialization'),
          SizedBox(height: 8.h),
          _buildDropdown(
            value: filter.specialization,
            items: validSpecs,
            hint: 'Select Specialization',
            onChanged: (val) {
              setState(() {
                filter.specialization = val;
              });
            },
          ),
          if (filter.specialization == 'Others') ...[
            SizedBox(height: 12.h),
            _buildTextField('Enter custom specialization', _customFieldController),
          ],
          SizedBox(height: 24.h),
        ],

        _buildSectionLabel('Experience'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: JobFilterConfiguration.experienceLevels
              .map((exp) => _buildChip(
                    label: exp,
                    isSelected: filter.experience == exp,
                    onTap: () => setState(() => filter.experience = exp),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Employment Type'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: JobFilterConfiguration.employmentTypes
              .map((type) => _buildChip(
                    label: type,
                    isSelected: filter.employmentType == type,
                    onTap: () => setState(() => filter.employmentType = type),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildSectionLabel('Salary Type'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: JobFilterConfiguration.salaryTypes
              .map((type) => _buildChip(
                    label: type,
                    isSelected: filter.salaryType == type,
                    onTap: () => setState(() => filter.salaryType = type),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),

        _buildLocationAndDistance(filter.distance, (val) => setState(() => filter.distance = val), JobFilterConfiguration.distances),

        SizedBox(height: 24.h),
        _buildSortOptions(filter.sortBy, (val) => setState(() => filter.sortBy = val), JobFilterConfiguration.sortOptions),
      ],
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

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    bool disabled = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFF0F0F0) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textLightGray)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGray),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textBlack)),
            );
          }).toList(),
          onChanged: disabled ? null : onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textBlack),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textLightGray),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildLocationAndDistance(String? currentDistance, Function(String) onDistanceChanged, List<String> distances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Location'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildTextField('State', _locationStateController)),
            SizedBox(width: 8.w),
            Expanded(child: _buildTextField('District', _locationDistrictController)),
            SizedBox(width: 8.w),
            Expanded(child: _buildTextField('Mandal', _locationMandalController)),
          ],
        ),
        SizedBox(height: 24.h),
        _buildSectionLabel('Distance'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: distances
              .map((dist) => _buildChip(
                    label: dist,
                    isSelected: currentDistance == dist,
                    onTap: () => onDistanceChanged(dist),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSortOptions(String currentSort, Function(String) onSortChanged, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Sort By'),
        SizedBox(height: 12.h),
        ...options.map((label) {
          final isSelected = currentSort == label;
          return GestureDetector(
            onTap: () => onSortChanged(label),
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
        }),
      ],
    );
  }
}
