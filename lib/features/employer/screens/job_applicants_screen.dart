import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import '../../../core/services/application_service.dart';
import 'applicant_details_screen.dart';

class JobApplicantsScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final bool isWork;

  const JobApplicantsScreen({
    super.key,
    required this.job,
    this.isWork = false,
  });

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  List<Map<String, dynamic>> _applicants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  Future<void> _loadApplicants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final jobId = widget.job['_id'] as String? ?? '';
    final result = await ApplicationService.instance.getJobApplicants(jobId);

    if (result.success && result.data != null) {
      final List<dynamic> list = result.data!['data'] as List<dynamic>? ?? [];
      setState(() {
        _applicants = list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.error ?? 'Failed to load applicants.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Applicants',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildJobHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryPurple),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: GoogleFonts.poppins(color: Colors.red)),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: _loadApplicants,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_applicants.isEmpty) {
      return Center(
        child: Text(
          'No applicants yet.',
          style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApplicants,
      color: AppColors.primaryPurple,
      child: ListView.builder(
        padding: EdgeInsets.all(24.w),
        physics: const BouncingScrollPhysics(),
        itemCount: _applicants.length,
        itemBuilder: (context, index) {
          final app = _applicants[index];
          return _buildApplicantCard(context, app);
        },
      ),
    );
  }

  Widget _buildJobHeader() {
    final wage = widget.job['salary'] ?? widget.job['wage'] ?? 'N/A';
    final isActive = widget.job['isActive'] as bool? ?? true;

    // Location formatting
    String locText = 'Machilipatnam, Krishna District';
    final loc = widget.job['location'] as Map?;
    if (loc != null) {
      final state = loc['state'] ?? '';
      final dist = loc['district'] ?? '';
      final mandal = loc['mandal'] ?? '';
      final village = loc['village'] ?? '';
      locText = [village, mandal, dist, state].where((s) => s.isNotEmpty).join(', ');
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      color: const Color(0xFFF9FAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'CLOSED',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Rs. $wage',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.job['title'] ?? 'Title',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            locText,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> app) {
    final workerProfile = app['workerProfileId'] as Map<String, dynamic>? ?? {};
    final manager = app['appliedByUserId'] as Map<String, dynamic>?;
    
    final name = workerProfile['name'] ?? workerProfile['ownerName'] ?? 'Unknown Worker';
    final skill = workerProfile['primarySkill'] ?? 'General Labour';
    final photo = workerProfile['profilePhoto'] as String? ?? 'https://i.pravatar.cc/150?u=$name';
    
    final bool isManaged = manager != null && workerProfile['managerUserId'] != null;
    final String managerName = manager?['name'] ?? manager?['phone'] ?? 'User';
    final String relationship = workerProfile['relationship'] ?? 'Managed';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicantDetailsScreen(
              isWork: widget.isWork,
              applicant: app, 
              job: widget.job,
            ),
          ),
        );
        _loadApplicants(); 
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
              imageUrl: photo,
              width: 56.r,
              height: 56.r,
              isAvatar: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    skill,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  if (isManaged) ...[
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Managed By: $managerName ($relationship)',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLightGray, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
