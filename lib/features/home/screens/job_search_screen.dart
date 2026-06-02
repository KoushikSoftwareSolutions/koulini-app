import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/job_card.dart';

import 'job_details_screen.dart';
import 'confirm_application_screen.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['Masonry', 'Farming near Pedana', 'Painting', 'Plumbing'];
  final List<String> _trending = ['Daily Wages', 'Weekly Contract', 'Construction', 'Delivery'];
  
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSelected(String query) {
    setState(() {
      _searchController.text = query;
      _isSearching = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 22.sp),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 20.sp, color: AppColors.textLightGray),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: (val) {
                            setState(() {
                              _isSearching = val.isNotEmpty;
                            });
                          },
                          style: GoogleFonts.poppins(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: 'Search jobs, skills...',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: AppColors.textLightGray.withValues(alpha: 0.6),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _isSearching = false);
                          },
                          child: Icon(Icons.close_rounded, size: 18.sp, color: AppColors.textLightGray),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchSuggestions(),
    );
  }
  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent Searches'),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: _recentSearches.map((s) => _buildSearchTag(s)).toList(),
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader('Trending Categories'),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _trending.length,
            separatorBuilder: (context, index) => Divider(color: const Color(0xFFF1F1F1), height: 32.h),
            itemBuilder: (context, index) {
              final term = _trending[index];
              return InkWell(
                onTap: () => _onSearchSelected(term),
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.trending_up_rounded, color: AppColors.primaryPurple, size: 18.sp),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        term,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.north_west_rounded, size: 16.sp, color: AppColors.textLightGray),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
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

  Widget _buildSearchTag(String text) {
    return GestureDetector(
      onTap: () => _onSearchSelected(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.textGray,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.history_rounded, size: 14.sp, color: AppColors.textLightGray),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      physics: const BouncingScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        final job = {
          'title': index == 0 ? 'Expert Mason' : 'Construction Helper',
          'company': 'Reddy Builders',
          'location': 'Machilipatnam, Krishna',
          'salary': index == 0 ? '800/day' : '500/day',
          'duration': index == 0 ? '10 days' : '30 days',
          'workers': index == 0 ? '2 workers' : '5 workers',
          'posted': '2 hours ago',
        };
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: JobCard(
            title: job['title']!,
            company: job['company']!,
            location: job['location']!,
            salary: job['salary']!,
            statusText: 'New',
            statusColor: AppColors.primaryPurple,
            onApply: () => _navigateToConfirm(context, job),
            onTap: () => _navigateToDetails(context, job),
          ),
        );
      },
    );
  }
}
