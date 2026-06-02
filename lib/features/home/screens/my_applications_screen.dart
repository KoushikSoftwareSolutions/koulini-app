import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import 'application_details_pending_screen.dart';
import 'application_details_approved_screen.dart';
import 'application_details_rejected_screen.dart';
import '../../../../main.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final List<String> _filters = ['All (8)', 'Pending', 'Approved', 'Rejected'];
  int _activeFilterIndex = 0;

  final List<Map<String, dynamic>> _mockApplications = [
    {
      'title': 'Mason Required',
      'company': 'Vijay Constructions',
      'time': 'Applied 2 days ago',
      'status': 'Pending',
      'statusColor': const Color(0xFFFF9800),
      'statusBg': const Color(0xFFFFF3E0),
    },
    {
      'title': 'Farm Labour',
      'company': 'Reddys Farm',
      'time': 'Applied 5 days ago',
      'status': 'Approved',
      'statusColor': const Color(0xFF4CAF50),
      'statusBg': const Color(0xFFE8F5E9),
      'isApproved': true,
    },
    {
      'title': 'Shop Assistant',
      'company': 'Lalitha Stores',
      'time': 'Applied 1 week ago',
      'status': 'Rejected',
      'statusColor': const Color(0xFFF44336),
      'statusBg': const Color(0xFFFFEBEE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
              child: Text(
                'My Applications',
                style: AppTextStyles.questionTitle.copyWith(
                  fontSize: 28.sp,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            _buildFilterTabs(),
            Expanded(
              child: _buildApplicationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _activeFilterIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilterIndex = index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected 
                      ? AppColors.primaryPurple 
                      : AppColors.borderGray.withValues(alpha: 0.1),
                  ),
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

  Widget _buildApplicationList() {
    // Filter logic based on status
    final filteredApps = _activeFilterIndex == 0 
        ? _mockApplications 
        : _mockApplications.where((app) => 
            app['status'].toLowerCase() == _filters[_activeFilterIndex].toLowerCase()).toList();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(24.w),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        return _buildApplicationCard(filteredApps[index]);
      },
    );
  }

  void _navigateToDetails(Map<String, dynamic> app) {
    Widget targetScreen;
    if (app['status'] == 'Pending') {
      targetScreen = PendingApplicationDetailsScreen(application: app);
    } else if (app['status'] == 'Approved') {
      targetScreen = ApprovedApplicationDetailsScreen(application: app);
    } else {
      targetScreen = RejectedApplicationDetailsScreen(application: app);
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
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

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    final isApproved = app['isApproved'] ?? false;
    
    return GestureDetector(
      onTap: () => _navigateToDetails(app),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                app['time'],
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: app['statusBg'],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  app['status'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: app['statusColor'],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            app['title'],
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            app['company'],
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
          if (isApproved) ...[
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => _showContactDetails(context, app),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1BAB4F), // High-fidelity Green
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    MyApp.userRole == 'Worker' ? "View Business Owner's Contact" : 'View Employer Contact',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward_rounded, size: 18.sp),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

  void _showContactDetails(BuildContext context, Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderGray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, color: const Color(0xFF2E7D32), size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyApp.userRole == 'Worker' ? "Business Owner's Contact" : 'Employer Contact',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                    Text(
                      app['company'],
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32.h),
            _buildContactInfoRow(Icons.person_outline_rounded, 'Contact Person', 'Srikanth Reddy'),
            SizedBox(height: 20.h),
            _buildContactInfoRow(Icons.phone_outlined, 'Phone Number', '+91 98765 43210'),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                // Call trigger (Mocked)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Initiating call...'),
                    backgroundColor: AppColors.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1BAB4F),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Call Now',
                    style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textLightGray),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textLightGray),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15.sp, 
                fontWeight: FontWeight.w600, 
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
