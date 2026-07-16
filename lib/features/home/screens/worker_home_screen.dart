import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/services/job_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../main.dart';
import '../widgets/job_card.dart';
import '../widgets/role_aware_filter_bottom_sheet.dart';
import '../../../core/services/filter_storage_service.dart';
import 'job_details_screen.dart';
import 'confirm_application_screen.dart';
import 'notifications_screen.dart';
import 'job_search_screen.dart';


class WorkerHomeScreen extends StatefulWidget {
  final VoidCallback? onRequestsTap;
  const WorkerHomeScreen({super.key, this.onRequestsTap});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  List<String> get _filters => const ['All', 'Near Me', 'Today', 'Food & Grocery', 'Salons & Services'];
  int _selectedFilterIndex = 0;
  List<dynamic> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authState = Provider.of<AuthState>(context, listen: false);
    final profile = authState.profile;
    final loc = profile?['location'] as Map<String, dynamic>?;

    final workerFilter = MyApp.userRole == 'Worker' ? await FilterStorageService.instance.getWorkerFilter() : null;
    final jobFilter = MyApp.userRole != 'Worker' ? await FilterStorageService.instance.getJobFilter() : null;

    final result = await JobService.instance.getJobsFeed(
      isWork: MyApp.userRole == 'Worker',
      state: loc?['state'],
      district: loc?['district'],
      mandal: loc?['mandal'],
      workerFilter: workerFilter,
      jobFilter: jobFilter,
    );

    if (!mounted) return;

    if (result.success && result.data != null) {
      setState(() {
        _jobs = result.data!['data'] as List<dynamic>? ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.error ?? 'Failed to load work feed.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchJobs,
          color: AppColors.primaryPurple,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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
      ),
    );
  }

  Widget _buildHeader() {
    final authState = Provider.of<AuthState>(context);
    final profile = authState.profile;
    final String name = profile?['name'] ?? profile?['ownerName'] ?? 'User';
    final loc = profile?['location'] as Map<String, dynamic>?;
    final String locationName = loc != null 
        ? '${loc['mandal'] ?? loc['village'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : 'Krishna, Andhra Pradesh';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, $name!',
                style: AppTextStyles.questionTitle.copyWith(fontSize: 22.sp),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: AppColors.textLightGray),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      locationName,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textLightGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
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
                  Flexible(
                    child: Text(
                      MyApp.userRole == 'Worker' ? 'Search work, skills, locations...' : 'Search jobs, skills, locations...',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textLightGray.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const RoleAwareFilterBottomSheet(),
            );
            if (result != null) {
               _fetchJobs();
            }
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
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: Colors.redAccent),
            SizedBox(height: 12.h),
            Text(_errorMessage!, style: GoogleFonts.poppins(color: AppColors.textGray)),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: _fetchJobs,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Apply filtering based on selected chip index
    List<dynamic> filtered = List.from(_jobs);

    final authState = Provider.of<AuthState>(context, listen: false);
    final profile = authState.profile;
    final loc = profile?['location'] as Map<String, dynamic>?;
    final mandal = loc?['mandal']?.toString().toLowerCase();

    if (_selectedFilterIndex == 1) {
      // Near Me
      if (mandal != null) {
        filtered = filtered.where((job) {
          final jobLoc = job['location'] as Map<String, dynamic>?;
          return jobLoc?['mandal']?.toString().toLowerCase() == mandal;
        }).toList();
      }
    } else if (_selectedFilterIndex == 2) {
      // Today
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      filtered = filtered.where((job) {
        final posted = job['postedAt']?.toString() ?? '';
        return posted.startsWith(todayStr);
      }).toList();
    } else if (_selectedFilterIndex == 3) {
      // Food & Grocery
      filtered = filtered.where((job) {
        final cat = job['category']?.toString().toLowerCase() ?? '';
        return cat.contains('food') || cat.contains('grocery');
      }).toList();
    } else if (_selectedFilterIndex == 4) {
      // Salons & Services
      filtered = filtered.where((job) {
        final cat = job['category']?.toString().toLowerCase() ?? '';
        return cat.contains('salon') || cat.contains('service');
      }).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Text(
            MyApp.userRole == 'Worker' ? 'No matching work found.' : 'No matching jobs found.',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Column(
      children: filtered.map((job) {
        final title = job['title'] ?? 'Worker Required';
        final jobLoc = job['location'] as Map<String, dynamic>? ?? {};
        final location = jobLoc['mandal'] ?? jobLoc['district'] ?? 'Krishna';
        final salary = job['salary']?.toString() ?? 'Negotiable';
        final payType = job['payType']?.toString() ?? 'Per Day';

        final isExpired = job['isActive'] == false;
        final statusText = isExpired ? 'Expired' : 'Active';
        final statusColor = isExpired ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32);

        final jobData = {
          'id': job['_id'],
          'title': title,
          'company': job['companyName'] ?? job['contactName'] ?? 'Business Owner',
          'location': '${jobLoc['mandal'] ?? ''}, ${jobLoc['district'] ?? ''}',
          'salary': '$salary/$payType',
          'duration': job['duration'] ?? 'Contract',
          'workers': '${job['numberOfOpenings'] ?? 1} openings',
          'posted': job['postedAt'] != null 
              ? DateTime.tryParse(job['postedAt'].toString())?.toLocal().toString().substring(0, 16) ?? 'Recently'
              : 'Recently',
          'description': job['description'] ?? '',
          'requirements': job['requirements'] ?? [],
          'isExpired': isExpired,
          'resumeRequired': job['resumeRequired'] ?? false,
        };

        return JobCard(
          title: title,
          company: jobData['company'].toString(),
          location: location,
          salary: '₹$salary/${payType.toLowerCase().replaceAll('per ', '')}',
          statusText: statusText,
          statusColor: statusColor,
          isExpired: isExpired,
          onApply: () => _navigateToConfirm(context, jobData),
          onTap: () => _navigateToDetails(context, jobData),
        );
      }).toList(),
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
