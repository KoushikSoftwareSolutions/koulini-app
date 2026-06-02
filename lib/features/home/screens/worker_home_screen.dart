import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';
import 'confirm_application_screen.dart';
import 'notifications_screen.dart';
import 'job_search_screen.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../../main.dart';

class WorkerHomeScreen extends StatefulWidget {
  final VoidCallback? onRequestsTap;
  const WorkerHomeScreen({super.key, this.onRequestsTap});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final List<String> _filters = ['All', 'Near Me', 'Today', 'Construction', 'Farming'];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 20.h),
              _buildFilterChips(),
              SizedBox(height: 32.h),
              _buildSectionHeader(),
              SizedBox(height: 16.h),
              _buildJobFeed(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Manoj!',
              style: AppTextStyles.questionTitle.copyWith(fontSize: 22.sp),
            ),
            Row(
              children: [
                Icon(Icons.location_on, size: 14.sp, color: AppColors.textLightGray),
                SizedBox(width: 4.w),
                Text(
                  'Machilipatnam, Krishna',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
          ),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.notifications_none_rounded, size: 24.sp, color: AppColors.textBlack),
                Positioned(
                  top: 10.h,
                  right: 12.w,
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
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JobSearchScreen()),
            ),
            child: Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 22.sp, color: AppColors.textLightGray),
                  SizedBox(width: 12.w),
                  Text(
                    MyApp.userRole == 'Worker' ? 'Search work, skills, locations...' : 'Search jobs, skills, locations...',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.textLightGray.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const FilterBottomSheet(),
            );
          },
          child: Container(
            width: 52.h,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
            ),
            child: Icon(Icons.tune_rounded, size: 22.sp, color: AppColors.textBlack),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _filters[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textGray,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MyApp.userRole == 'Worker' ? 'Work near you' : 'Jobs near you',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        Text(
          'See all',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildJobFeed() {
    return Column(
      children: [
        JobCard(
          title: 'Mason Required',
          company: 'Vijay Constructions',
          location: 'Machilipatnam',
          salary: '700/day',
          statusText: 'Expires today',
          statusColor: const Color(0xFFF57C00), // Orange
          onApply: () => _navigateToConfirm(context, {
            'title': 'Mason Required',
            'company': 'Vijay Constructions',
            'location': 'Machilipatnam, Krishna',
            'salary': '700/day',
            'duration': '15 days (Contract)',
            'workers': '3 workers needed',
            'posted': 'Today, 10:30 AM',
          }),
          onTap: () => _navigateToDetails(context, {
            'title': 'Mason Required',
            'company': 'Vijay Constructions',
            'location': 'Machilipatnam, Krishna',
            'salary': '700/day',
            'duration': '15 days (Contract)',
            'workers': '3 workers needed',
            'posted': 'Today, 10:30 AM',
          }),
        ),
        JobCard(
          title: 'Farm Labour Needed',
          company: 'Pedana Village',
          location: 'reddy Farm',
          salary: '450/day',
          statusText: 'Expired',
          statusColor: const Color(0xFFD32F2F), // Red
          isExpired: true,
          onApply: () => _navigateToConfirm(context, {
            'title': 'Farm Labour Needed',
            'company': 'Pedana Village',
            'location': 'Pedana, Krishna',
            'salary': '450/day',
            'duration': '7 days (Contract)',
            'workers': '10 workers needed',
            'posted': 'Yesterday, 4:00 PM',
          }),
          onTap: () => _navigateToDetails(context, {
            'title': 'Farm Labour Needed',
            'company': 'Pedana Village',
            'location': 'Pedana, Krishna',
            'salary': '450/day',
            'duration': '7 days (Contract)',
            'workers': '10 workers needed',
            'posted': 'Yesterday, 4:00 PM',
            'isExpired': true,
          }),
        ),
        JobCard(
          title: 'Shop Assistant',
          company: 'Gudivada',
          location: 'Lalitha Stores',
          salary: '350/day',
          statusText: 'Expires in 3 days',
          statusColor: const Color(0xFFF57C00), // Orange
          onApply: () => _navigateToConfirm(context, {
            'title': 'Shop Assistant',
            'company': 'Gudivada',
            'location': 'Gudivada, Krishna',
            'salary': '350/day',
            'duration': '30 days',
            'workers': '1 worker needed',
            'posted': 'Today, 9:00 AM',
          }),
          onTap: () => _navigateToDetails(context, {
            'title': 'Shop Assistant',
            'company': 'Gudivada',
            'location': 'Gudivada, Krishna',
            'salary': '350/day',
            'duration': '30 days',
            'workers': '1 worker needed',
            'posted': 'Today, 9:00 AM',
          }),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context, Map<String, dynamic> jobData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => JobDetailsScreen(job: jobData),
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
  }

  void _navigateToConfirm(BuildContext context, Map<String, dynamic> jobData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ConfirmApplicationScreen(job: jobData),
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
  }
}
