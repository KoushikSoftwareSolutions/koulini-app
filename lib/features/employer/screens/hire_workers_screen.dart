import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_image.dart';
import '../widgets/filter_chip_group.dart';
import 'worker_view_screen.dart';

class HireWorkersScreen extends StatefulWidget {
  const HireWorkersScreen({super.key});

  @override
  State<HireWorkersScreen> createState() => _HireWorkersScreenState();
}

class _HireWorkersScreenState extends State<HireWorkersScreen> {
  // Filter states
  String _selectedExperience = 'All';
  double _minRating = 0;
  final Set<String> _selectedSkills = {};

  // Search state
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild to filter list as users type
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            _buildSearchAndFilters(),
            Expanded(
              child: _buildWorkerList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Nearby Talent',
            style: AppTextStyles.questionTitle.copyWith(
              fontSize: 28.sp,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Discover skilled workers in Machilipatnam',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: AppColors.primaryPurple,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textBlack,
                ),
                decoration: InputDecoration(
                  hintText: 'Search skills or names',
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.textLightGray,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textLightGray, size: 20.sp),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _searchController.clear(),
                          child: Icon(Icons.close_rounded, color: AppColors.textLightGray, size: 18.sp),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.tune_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSheetContent(
        initialExperience: _selectedExperience,
        initialRating: _minRating,
        initialSkills: _selectedSkills,
        onApply: (exp, rating, skills) {
          setState(() {
            _selectedExperience = exp;
            _minRating = rating;
            _selectedSkills.clear();
            _selectedSkills.addAll(skills);
          });
        },
      ),
    );
  }

  Widget _buildWorkerList(BuildContext context) {
    // Mock data for workers
    final allWorkers = [
      {
        'name': 'Manoj Kumar',
        'skill': 'Mason',
        'rating': '4.8',
        'experience': '2 yrs',
        'jobs': '15',
        'avatar': 'https://i.pravatar.cc/150?u=manoj',
      },
      {
        'name': 'Suresh V.',
        'skill': 'Painter',
        'rating': '4.5',
        'experience': '5 yrs',
        'jobs': '42',
        'avatar': 'https://i.pravatar.cc/150?u=suresh',
      },
      {
        'name': 'Rajesh Singh',
        'skill': 'Electrician',
        'rating': '4.9',
        'experience': '3 yrs',
        'jobs': '28',
        'avatar': 'https://i.pravatar.cc/150?u=rajesh',
      },
    ];

    // Complex filtering logic: Search + Filters
    final filteredWorkers = allWorkers.where((worker) {
      final query = _searchController.text.toLowerCase();
      final nameMatches = worker['name']!.toLowerCase().contains(query);
      final skillMatches = worker['skill']!.toLowerCase().contains(query);
      final searchMatch = query.isEmpty || nameMatches || skillMatches;

      final expMatch = _selectedExperience == 'All' || worker['experience']!.contains(_selectedExperience.split(' ')[0]);
      final ratingMatch = double.parse(worker['rating']!) >= _minRating;
      final skillFilterMatch = _selectedSkills.isEmpty || _selectedSkills.contains(worker['skill']);

      return searchMatch && expMatch && ratingMatch && skillFilterMatch;
    }).toList();

    if (filteredWorkers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_rounded, size: 64.sp, color: AppColors.borderGray),
            SizedBox(height: 16.h),
            Text(
              'No workers match your filters',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: AppColors.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredWorkers.length,
      itemBuilder: (context, index) {
        return _buildWorkerCard(context, filteredWorkers[index]);
      },
    );
  }

  Widget _buildWorkerCard(BuildContext context, Map<String, dynamic> worker) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerViewScreen(worker: worker),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            PremiumImage(
              imageUrl: worker['avatar']!,
              width: 64.r,
              height: 64.r,
              isAvatar: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        worker['name']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9C4),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFFBC02D)),
                            SizedBox(width: 4.w),
                            Text(
                              worker['rating']!,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF57F17),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    worker['skill']!,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildWorkerBadge('${worker['experience']} Exp'),
                      SizedBox(width: 8.w),
                      _buildWorkerBadge('${worker['jobs']} Jobs Completed'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }
}

class _FilterSheetContent extends StatefulWidget {
  final String initialExperience;
  final double initialRating;
  final Set<String> initialSkills;
  final Function(String, double, Set<String>) onApply;

  const _FilterSheetContent({
    required this.initialExperience,
    required this.initialRating,
    required this.initialSkills,
    required this.onApply,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  late String _tempExperience;
  late double _tempRating;
  late Set<String> _tempSkills;

  @override
  void initState() {
    super.initState();
    _tempExperience = widget.initialExperience;
    _tempRating = widget.initialRating;
    _tempSkills = Set.from(widget.initialSkills);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderGray.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Talent',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempExperience = 'All';
                      _tempRating = 0;
                      _tempSkills.clear();
                    });
                  },
                  child: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterChipGroup(
                    title: 'Experience Level',
                    options: const ['All', '0-2 yrs', '2-5 yrs', '5+ yrs'],
                    selectedOption: _tempExperience,
                    onSelected: (val) => setState(() => _tempExperience = val),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Minimum Rating',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: List.generate(5, (index) {
                      final starVal = index + 1.0;
                      final isSelected = starVal <= _tempRating;
                      return GestureDetector(
                        onTap: () => setState(() => _tempRating = starVal),
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Icon(
                            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 32.sp,
                            color: isSelected ? const Color(0xFFFBC02D) : AppColors.borderGray,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Preferred Skills',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: ['Mason', 'Painter', 'Electrician', 'Plumber', 'Carpenter', 'Cook', 'Driver'].map((skill) {
                      final isSelected = _tempSkills.contains(skill);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _tempSkills.remove(skill);
                            } else {
                              _tempSkills.add(skill);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryPurple : AppColors.borderGray,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            skill,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.primaryPurple : AppColors.textGray,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_tempExperience, _tempRating, _tempSkills);
                Navigator.pop(context);
              },
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
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
