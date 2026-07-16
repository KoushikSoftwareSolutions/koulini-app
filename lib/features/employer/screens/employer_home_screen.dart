import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/job_service.dart';
import '../../home/screens/notifications_screen.dart';
import 'create_job_screen.dart';
import 'job_applicants_screen.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  bool _showWork = true; // Toggle between Job and Work postings - Work by default
  String _selectedFilter = 'All'; // Filter by: All, Active, Closed

  List<Map<String, dynamic>> _allPostings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPostings();
  }

  Future<void> _loadPostings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await JobService.instance.getEmployerJobs();

    if (!mounted) return;

    if (result.success && result.data != null) {
      final List<dynamic> list = result.data!['data'] as List<dynamic>? ?? [];
      setState(() {
        _allPostings = list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.error ?? 'Failed to load postings.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: GoogleFonts.poppins(color: Colors.red)),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: _loadPostings,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final postings = _allPostings.where((p) => (p['isWork'] as bool? ?? false) == _showWork).toList();

    final filteredPostings = postings.where((p) {
      final isActive = p['isActive'] as bool? ?? true;
      final statusStr = isActive ? 'Active' : 'Closed';
      if (_selectedFilter == 'All') return true;
      return statusStr == _selectedFilter;
    }).toList();

    // Stats calculations
    final activeCount = postings.where((p) => (p['isActive'] as bool? ?? true)).length;
    final totalApplicants = postings.fold<int>(0, (sum, item) => sum + (item['applicants'] as int? ?? 0));
    final approvedCount = postings.fold<int>(0, (sum, item) => sum + (item['approved'] as int? ?? 0));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildToggle(),
            _buildStatsCard(activeCount, totalApplicants, approvedCount),
            _buildFilterChips(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPostings,
                color: AppColors.primaryPurple,
                child: _buildPostingsList(filteredPostings),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateJobScreen(isWork: _showWork),
            ),
          );
          _loadPostings(); // reload after posting
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          _showWork ? 'Post Work' : 'Post Job',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Koulini',
                style: AppTextStyles.questionTitle.copyWith(fontSize: 24.sp, color: AppColors.textBlack),
              ),
              Text(
                'Manage postings and hires',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textLightGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                ),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 24.sp, color: AppColors.textBlack),
                      Positioned(
                        top: 8.h,
                        right: 10.w,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                child: Icon(Icons.business_rounded, color: AppColors.primaryPurple, size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showWork = true),
                child: Container(
                  decoration: BoxDecoration(
                    color: _showWork ? AppColors.primaryPurple : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Work',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: _showWork ? Colors.white : AppColors.textLightGray,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showWork = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: !_showWork ? AppColors.primaryPurple : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Jobs',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: !_showWork ? Colors.white : AppColors.textLightGray,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(int active, int applicants, int approved) {
    final activeLabel = _showWork ? 'Active Work' : 'Active Jobs';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatsCardItem(active.toString(), activeLabel),
            _buildDivider(),
            _buildStatsCardItem(applicants.toString(), 'Applicants'),
            _buildDivider(),
            _buildStatsCardItem(approved.toString(), 'Approved'),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 32.h,
      width: 1.w,
      color: AppColors.borderGray.withValues(alpha: 0.3),
    );
  }

  Widget _buildStatsCardItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.textLightGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Closed'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryPurple : AppColors.borderGray.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textGray,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostingsList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          _showWork ? 'No work postings found' : 'No job postings found',
          style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final bool isActive = item['isActive'] as bool? ?? true;
        final statusText = isActive ? 'Active' : 'Closed';

        // Parse date
        String formattedDate = '';
        try {
          final parsedDate = DateTime.parse(item['postedAt'] as String);
          formattedDate = DateFormat('dd MMM').format(parsedDate);
        } catch (_) {
          formattedDate = 'Recently';
        }

        void navigateToApplicants() async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobApplicantsScreen(
                job: item,
                isWork: _showWork,
              ),
            ),
          );
          _loadPostings(); // reload on return in case status changed
        }

        return GestureDetector(
          onTap: navigateToApplicants,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] ?? 'Title',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Posted on $formattedDate',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(color: AppColors.borderGray.withValues(alpha: 0.1), height: 1.h),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['applicants'] ?? 0} Applicants',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToApplicants,
                      child: Row(
                        children: [
                          Text(
                            'View all',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14.sp,
                            color: AppColors.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
