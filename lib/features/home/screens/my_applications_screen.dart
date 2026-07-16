import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/application_service.dart';
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
  final List<String> _filterKeys = ['All', 'Pending', 'Approved', 'Rejected', 'Completed'];
  int _activeFilterIndex = 0;
  List<dynamic> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ApplicationService.instance.getWorkerApplications();

    if (!mounted) return;

    if (result.success && result.data != null) {
      setState(() {
        _applications = result.data!['data'] as List<dynamic>? ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.error ?? 'Failed to load applications.';
        _isLoading = false;
      });
    }
  }

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
                MyApp.userRole == 'Jobs' ? 'My Job' : 'My Applications',
                style: AppTextStyles.questionTitle.copyWith(
                  fontSize: 28.sp,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            _buildFilterTabs(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      'All (${_applications.length})',
      'Pending',
      'Approved',
      'Rejected',
      'Completed'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: List.generate(filters.length, (index) {
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
                  filters[index],
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64.sp, color: Colors.redAccent),
            SizedBox(height: 16.h),
            Text(
              _errorMessage!,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: AppColors.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _fetchApplications,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Filter logic based on key
    final filteredApps = _activeFilterIndex == 0 
        ? _applications 
        : _applications.where((app) => 
            app['status']?.toString().toLowerCase() == _filterKeys[_activeFilterIndex].toLowerCase()).toList();

    if (filteredApps.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchApplications,
        color: AppColors.primaryPurple,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 64.sp, color: AppColors.borderGray),
                  SizedBox(height: 16.h),
                  Text(
                    'No applications found',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchApplications,
      color: AppColors.primaryPurple,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.all(24.w),
        itemCount: filteredApps.length,
        itemBuilder: (context, index) {
          return _buildApplicationCard(filteredApps[index]);
        },
      ),
    );
  }

  void _navigateToDetails(Map<String, dynamic> app) {
    Widget targetScreen;
    if (app['status'] == 'Pending') {
      targetScreen = PendingApplicationDetailsScreen(application: app);
    } else if (app['status'] == 'Approved' || app['status'] == 'Completed') {
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

  Widget _buildApplicationCard(dynamic item) {
    final job = item['job'] as Map<String, dynamic>? ?? {};
    final status = item['status']?.toString() ?? 'Pending';
    final isApproved = status == 'Approved';
    final company = job['companyName'] ?? 'Vijay Constructions';
    final title = job['title'] ?? 'Worker Required';
    
    DateTime? appliedDate;
    if (item['appliedAt'] != null) {
      appliedDate = DateTime.tryParse(item['appliedAt'].toString());
    }
    
    final diffDays = appliedDate != null ? DateTime.now().difference(appliedDate).inDays : 0;
    final timeStr = diffDays == 0 
        ? 'Applied today' 
        : (diffDays == 1 ? 'Applied 1 day ago' : 'Applied $diffDays days ago');

    Color statusColor = const Color(0xFFFF9800);
    Color statusBg = const Color(0xFFFFF3E0);
    if (status == 'Approved') {
      statusColor = const Color(0xFF4CAF50);
      statusBg = const Color(0xFFE8F5E9);
    } else if (status == 'Rejected') {
      statusColor = const Color(0xFFF44336);
      statusBg = const Color(0xFFFFEBEE);
    } else if (status == 'Completed') {
      statusColor = const Color(0xFF2196F3);
      statusBg = const Color(0xFFE3F2FD);
    }
    
    return GestureDetector(
      onTap: () => _navigateToDetails({
        '_id': item['_id'],
        'status': status,
        'title': title,
        'company': company,
        'time': timeStr,
        ...job,
      }),
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
                  timeStr,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              company,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textLightGray,
              ),
            ),
            if (isApproved) ...[
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => _showContactDetails(context, {
                  'company': company,
                  ...job,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BAB4F),
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
                    Flexible(
                      child: Text(
                        MyApp.userRole == 'Worker' ? "View Business Owner's Contact" : 'View Employer Contact',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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

  void _showContactDetails(BuildContext context, Map<String, dynamic> job) {
    final company = job['companyName'] ?? 'Business Owner';
    final contactPerson = job['contactName'] ?? 'Srikanth Reddy';
    final phone = job['phone'] ?? '+91 XXXXX XXXXX';

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
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, color: const Color(0xFF2E7D32), size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
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
                        company,
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            _buildContactInfoRow(Icons.person_outline_rounded, 'Contact Person', contactPerson),
            SizedBox(height: 20.h),
            _buildContactInfoRow(Icons.phone_outlined, 'Phone Number', phone),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (phone.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: phone));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Phone number $phone copied to clipboard!'),
                      backgroundColor: AppColors.primaryPurple,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
        Expanded(
          child: Column(
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
