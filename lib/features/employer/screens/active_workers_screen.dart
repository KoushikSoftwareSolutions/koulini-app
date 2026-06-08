import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/application_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_image.dart';
import '../../chat/screens/chat_detail_screen.dart';

class ActiveWorkersScreen extends StatefulWidget {
  const ActiveWorkersScreen({super.key});

  @override
  State<ActiveWorkersScreen> createState() => _ActiveWorkersScreenState();
}

class _ActiveWorkersScreenState extends State<ActiveWorkersScreen> {
  List<dynamic> _activeHires = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchActiveWorkers();
  }

  Future<void> _fetchActiveWorkers() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ApplicationService.instance.getEmployerApplications();

    if (!mounted) return;

    if (result.success && result.data != null) {
      final list = result.data!['data'] as List<dynamic>? ?? [];
      // Filter for approved or completed applications
      final activeList = list.where((app) => 
        app['status'] == 'Approved' || app['status'] == 'Completed'
      ).toList();
      setState(() {
        _activeHires = activeList;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.error ?? 'Failed to load active workers.';
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
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),
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
            'Active Workers',
            style: AppTextStyles.questionTitle.copyWith(
              fontSize: 28.sp,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Manage your ongoing projects and crew',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
            ),
          ),
        ],
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
              onPressed: _fetchActiveWorkers,
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

    if (_activeHires.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchActiveWorkers,
        color: AppColors.primaryPurple,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.engineering_outlined, size: 64.sp, color: AppColors.borderGray),
                SizedBox(height: 16.h),
                Text(
                  'No active workers found',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start hiring to manage your crew here.',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchActiveWorkers,
      color: AppColors.primaryPurple,
      child: ListView.builder(
        padding: EdgeInsets.all(24.w),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: _activeHires.length,
        itemBuilder: (context, index) {
          return _buildActiveWorkerCard(_activeHires[index], index);
        },
      ),
    );
  }

  Widget _buildActiveWorkerCard(dynamic item, int index) {
    final worker = item['worker'] as Map<String, dynamic>? ?? {};
    final job = item['job'] as Map<String, dynamic>? ?? {};

    final String name = worker['name'] ?? 'Unknown';
    final String skill = worker['primarySkill'] ?? job['category'] ?? 'Worker';
    final String jobTitle = job['title'] ?? 'Job';
    final bool isCompleted = item['status'] == 'Completed';
    final String statusStr = isCompleted ? 'Job Completed' : 'Work in Progress';

    final avatar = (worker['profilePhoto'] != null && worker['profilePhoto'].toString().isNotEmpty)
        ? worker['profilePhoto'].toString()
        : 'https://i.pravatar.cc/150?u=${worker['_id'] ?? name}';

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              PremiumImage(
                imageUrl: avatar,
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
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      '$skill • $jobTitle',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ],
                ),
              ),
              _buildInteractionButtons(worker, name, avatar),
            ],
          ),
          SizedBox(height: 20.h),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    statusStr,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              if (!isCompleted)
                TextButton(
                  onPressed: () => _showCompletionDialog(index),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text(
                    'Update Status',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButtons(Map<String, dynamic> worker, String name, String avatar) {
    return Row(
      children: [
        _buildSmallIconBtn(Icons.phone_in_talk_rounded, Colors.green, () {
          final phone = worker['phone'] ?? '';
          if (phone.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: phone));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Phone number $phone copied to clipboard!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }),
        SizedBox(width: 12.w),
        _buildSmallIconBtn(Icons.chat_bubble_rounded, AppColors.primaryPurple, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                worker: {
                  'name': name,
                  'avatar': avatar,
                  ...worker,
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSmallIconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }

  void _showCompletionDialog(int index) {
    final item = _activeHires[index];
    final worker = item['worker'] as Map<String, dynamic>? ?? {};
    final String name = worker['name'] ?? 'Unknown';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Work Completed?',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Are you sure the work has been finished by $name?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        side: BorderSide(color: const Color(0xFFEEEEEE)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(
                        'Not Yet',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showRatingDialog(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Yes, Done',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(int index) {
    final item = _activeHires[index];
    final worker = item['worker'] as Map<String, dynamic>? ?? {};
    final String name = worker['name'] ?? 'Unknown';
    final String applicationId = item['_id']?.toString() ?? '';

    int selectedStars = 4;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, MediaQuery.of(context).viewInsets.bottom + 32.h),
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
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderGray.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Rate $name',
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your feedback helps maintain a high-quality community.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (starIdx) {
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedStars = starIdx + 1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        Icons.star_rounded,
                        size: 44.sp,
                        color: starIdx < selectedStars ? const Color(0xFFFBC02D) : const Color(0xFFE0E0E0),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a comment (Optional)',
                  hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textLightGray),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(20.w),
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  
                  if (!mounted) return;
                  setState(() {
                    _isLoading = true;
                  });

                  final result = await ApplicationService.instance.completeAndRateApplication(
                    applicationId: applicationId,
                    rating: selectedStars,
                    comment: commentController.text.trim().isNotEmpty ? commentController.text.trim() : null,
                  );

                  if (!mounted) return;

                  if (result.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for rating $name!'),
                        backgroundColor: AppColors.primaryPurple,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    _fetchActiveWorkers(); // Reload the list
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.error ?? 'Failed to complete work and submit rating.'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 0,
                ),
                child: Text(
                  'Submit Rating',
                  style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
