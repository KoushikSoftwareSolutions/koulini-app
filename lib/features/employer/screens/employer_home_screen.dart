import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/screens/notifications_screen.dart';
import 'create_job_screen.dart';
import 'job_applicants_screen.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  bool _showWork = false; // Toggle between Job and Work postings
  String _selectedFilter = 'All'; // Filter by: All, Active, Closed

  // Mock Data for Job Postings
  final List<Map<String, dynamic>> _mockJobs = [
    {
      'title': 'Mason / Construction worker',
      'date': '12 Mar',
      'applicants': 9,
      'status': 'Active',
      'wage': '600/day',
    },
    {
      'title': 'Painter - Interior work',
      'date': '8 Mar',
      'applicants': 3,
      'status': 'Active',
      'wage': '750/day',
    },
    {
      'title': 'Helper / general Labour',
      'date': '5 Mar',
      'applicants': 3,
      'status': 'Closed',
      'wage': '500/day',
    },
  ];

  // Mock Data for Work Postings
  final List<Map<String, dynamic>> _mockWorks = [
    {
      'title': 'Plumbing Fitting Work',
      'date': '10 Mar',
      'applicants': 4,
      'status': 'Active',
      'wage': '800/day',
    },
    {
      'title': 'Electrical Wiring Setup',
      'date': '6 Mar',
      'applicants': 7,
      'status': 'Active',
      'wage': '900/day',
    },
    {
      'title': 'Tile Repair & Fixing',
      'date': '3 Mar',
      'applicants': 2,
      'status': 'Closed',
      'wage': '850/day',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final postings = _showWork ? _mockWorks : _mockJobs;
    final filteredPostings = postings.where((p) {
      if (_selectedFilter == 'All') return true;
      return p['status'] == _selectedFilter;
    }).toList();

    // Stats calculations
    final activeCount = postings.where((p) => p['status'] == 'Active').length;
    final totalApplicants = postings.fold<int>(0, (sum, item) => sum + (item['applicants'] as int));
    const approvedCount = 2; // Static mock value

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
              child: _buildPostingsList(filteredPostings),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Posting Type',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ListTile(
                      leading: Icon(Icons.work_outline_rounded, color: AppColors.primaryPurple),
                      title: Text(
                        'Post a Work',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateJobScreen(isWork: true),
                          ),
                        );
                      },
                    ),
                    Divider(color: AppColors.borderGray.withValues(alpha: 0.1)),
                    ListTile(
                      leading: Icon(Icons.business_center_outlined, color: AppColors.primaryPurple),
                      title: Text(
                        'Post a Job',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateJobScreen(isWork: false),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Post Job',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final titleText = _showWork ? 'My Posted Work' : 'My Posted Jobs';
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: AppTextStyles.questionTitle.copyWith(
                  fontSize: 26.sp,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Ravi Builders',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
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
            _buildStatItem(active.toString(), activeLabel),
            _buildDivider(),
            _buildStatItem(applicants.toString(), 'Applicants'),
            _buildDivider(),
            _buildStatItem(approved.toString(), 'Approved'),
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

  Widget _buildStatItem(String count, String label) {
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
        final bool isActive = item['status'] == 'Active';

        return Container(
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
              // Title and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title']!,
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
                      item['status']!,
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
              
              // Posted Date
              Text(
                'Posted on ${item['date']}',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              SizedBox(height: 16.h),

              // Divider
              Divider(color: AppColors.borderGray.withValues(alpha: 0.1), height: 1.h),
              SizedBox(height: 12.h),

              // Applicants and View link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item['applicants']} Applicants',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobApplicantsScreen(
                            job: item,
                            isWork: _showWork,
                          ),
                        ),
                      );
                    },
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
        );
      },
    );
  }
}
