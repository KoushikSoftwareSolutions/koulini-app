import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/services/application_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import 'worker_view_screen.dart';

class HiringHistoryScreen extends StatefulWidget {
  const HiringHistoryScreen({super.key});

  @override
  State<HiringHistoryScreen> createState() => _HiringHistoryScreenState();
}

class _HiringHistoryScreenState extends State<HiringHistoryScreen> {
  List<dynamic> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHiringHistory();
  }

  Future<void> _fetchHiringHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ApplicationService.instance.getEmployerApplications();

    if (!mounted) return;

    if (result.success && result.data != null) {
      final list = result.data!['data'] as List<dynamic>? ?? [];
      // Filter for approved applications (hired workers)
      final approvedList = list.where((app) => app['status'] == 'Approved').toList();
      setState(() {
        _history = approvedList;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.error ?? 'Failed to load hiring history.';
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hiring History',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildBody(),
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
              onPressed: _fetchHiringHistory,
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

    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_rounded, size: 64.sp, color: AppColors.borderGray),
            SizedBox(height: 16.h),
            Text(
              'No hiring history found',
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

    return RefreshIndicator(
      onRefresh: _fetchHiringHistory,
      color: AppColors.primaryPurple,
      child: ListView.separated(
        padding: EdgeInsets.all(24.w),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: _history.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = _history[index];
          return _buildHistoryCard(context, item);
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, dynamic item) {
    final worker = item['worker'] as Map<String, dynamic>? ?? {};
    final job = item['job'] as Map<String, dynamic>? ?? {};
    final name = worker['name'] ?? 'Unknown';
    final role = job['title'] ?? 'General Posting';
    
    DateTime? appliedDate;
    if (item['appliedAt'] != null) {
      appliedDate = DateTime.tryParse(item['appliedAt'].toString());
    }
    final dateStr = appliedDate != null 
        ? DateFormat('MMM dd, yyyy').format(appliedDate) 
        : 'Unknown Date';

    final avatar = (worker['profilePhoto'] != null && worker['profilePhoto'].toString().isNotEmpty)
        ? worker['profilePhoto'].toString()
        : 'https://i.pravatar.cc/150?u=${worker['_id'] ?? name}';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerViewScreen(worker: worker),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEEEEEE)),
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
              imageUrl: avatar,
              width: 48.r,
              height: 48.r,
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
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    role,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateStr,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLightGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    item['status'] ?? 'Hired',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
