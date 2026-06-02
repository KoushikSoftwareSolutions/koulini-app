import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // Mock data for currently hired workers
  final List<Map<String, dynamic>> _activeHires = [
    {
      'name': 'Manoj Kumar',
      'skill': 'Masonry Work',
      'job': 'House Construction',
      'status': 'Work in Progress',
      'avatar': 'https://i.pravatar.cc/150?u=manoj',
      'isCompleted': false,
    },
    {
      'name': 'Suresh V.',
      'skill': 'Wall Painting',
      'job': 'Office Renovation',
      'status': 'Work in Progress',
      'avatar': 'https://i.pravatar.cc/150?u=suresh',
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _activeHires.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(24.w),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _activeHires.length,
                      itemBuilder: (context, index) {
                        return _buildActiveWorkerCard(_activeHires[index], index);
                      },
                    ),
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

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Widget _buildActiveWorkerCard(Map<String, dynamic> hire, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000), // Updated to opaque for const
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
                imageUrl: hire['avatar'],
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
                      hire['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      '${hire['skill']} • ${hire['job']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ],
                ),
              ),
              _buildInteractionButtons(hire),
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
                      color: hire['isCompleted'] ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    hire['isCompleted'] ? 'Job Completed' : hire['status'],
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: hire['isCompleted'] ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              if (!hire['isCompleted'])
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

  Widget _buildInteractionButtons(Map<String, dynamic> worker) {
    return Row(
      children: [
        _buildSmallIconBtn(Icons.phone_in_talk_rounded, Colors.green, () {}),
        SizedBox(width: 12.w),
        _buildSmallIconBtn(Icons.chat_bubble_rounded, AppColors.primaryPurple, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(worker: worker),
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
                'Are you sure the work has been finished by ${_activeHires[index]['name']}?',
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
                        setState(() {
                          _activeHires[index]['isCompleted'] = true;
                        });
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
    int selectedStars = 4;
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
                'Rate ${_activeHires[index]['name']}',
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
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for rating ${_activeHires[index]['name']}!'),
                      backgroundColor: AppColors.primaryPurple,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
