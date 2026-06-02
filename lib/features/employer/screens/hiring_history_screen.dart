import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import 'worker_view_screen.dart';

class HiringHistoryScreen extends StatelessWidget {
  const HiringHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for hiring history
    final history = [
      {
        'id': 'w1',
        'name': 'Manoj Kumar',
        'role': 'Masonry Work',
        'skill': 'Masonry Specialist',
        'date': 'Oct 12, 2023',
        'status': 'Completed',
        'avatar': 'https://i.pravatar.cc/150?u=manoj',
        'experience': '5 yrs',
        'rating': '4.9',
      },
      {
        'id': 'w2',
        'name': 'Suresh V.',
        'role': 'House Painting',
        'skill': 'Interior Designer & Painter',
        'date': 'Sep 28, 2023',
        'status': 'Completed',
        'avatar': 'https://i.pravatar.cc/150?u=suresh',
        'experience': '3 yrs',
        'rating': '4.7',
      },
      {
        'id': 'w3',
        'name': 'Anita R.',
        'role': 'Gardening',
        'skill': 'Landscape Expert',
        'date': 'Sep 15, 2023',
        'status': 'Completed',
        'avatar': 'https://i.pravatar.cc/150?u=anita',
        'experience': '4 yrs',
        'rating': '4.8',
      },
      {
        'id': 'w4',
        'name': 'Rajesh Singh',
        'role': 'Electrical Repair',
        'skill': 'Certified Electrician',
        'date': 'Aug 22, 2023',
        'status': 'Completed',
        'avatar': 'https://i.pravatar.cc/150?u=rajesh',
        'experience': '6 yrs',
        'rating': '4.6',
      },
    ];

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
        child: ListView.separated(
          padding: EdgeInsets.all(24.w),
          physics: const BouncingScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final item = history[index];
            return _buildHistoryCard(context, item);
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerViewScreen(worker: item),
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
            imageUrl: item['avatar']!,
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
                  item['name']!,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  item['role']!,
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
                item['date']!,
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
                  item['status']!,
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
