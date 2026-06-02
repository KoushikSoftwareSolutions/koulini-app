import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';

    final notifications = [
      {
        'title': isWorker ? 'Business Owner Interested!' : 'Employer Interested!',
        'message': isWorker
            ? 'A business owner from Reddy Builders is interested in your profile for Masonry Work.'
            : 'An employer from Reddy Builders is interested in your profile for Masonry Work.',
        'time': '2 mins ago',
        'type': 'request',
        'isUnread': true,
      },
      {
        'title': 'Application Accepted',
        'message': isWorker 
            ? 'Your application for "Farm Labour" at Pedana was accepted by the business owner.'
            : 'Your application for "Farm Labour" at Pedana was accepted by the employer.',
        'time': '1 hour ago',
        'type': 'accepted',
        'isUnread': true,
      },
      {
        'title': 'Profile Verified',
        'message': isWorker
            ? 'Your work gallery is now verified. Business owners can now find you easily!'
            : 'Your profile is now verified. Employers can now find you easily!',
        'time': 'Yesterday',
        'type': 'system',
        'isUnread': false,
      },
      {
        'title': isWorker ? 'New Work Near You' : 'New Job Near You',
        'message': isWorker 
            ? 'A business owner posted new "Painting Work" 2km from your location.'
            : 'An employer posted a new "Painting" job 2km from your location.',
        'time': '2 days ago',
        'type': 'job',
        'isUnread': false,
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
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(24.w),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final notify = notifications[index];
          return _buildNotificationItem(notify);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notify) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (notify['type']) {
      case 'request':
        icon = Icons.work_history_rounded;
        iconColor = AppColors.primaryPurple;
        bgColor = AppColors.primaryPurple.withValues(alpha: 0.1);
        break;
      case 'accepted':
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF2E7D32);
        bgColor = const Color(0xFFE8F5E9);
        break;
      case 'system':
        icon = Icons.verified_user_rounded;
        iconColor = const Color(0xFF1976D2);
        bgColor = const Color(0xFFE3F2FD);
        break;
      default:
        icon = Icons.notifications_active_rounded;
        iconColor = const Color(0xFFF57C00);
        bgColor = const Color(0xFFFFF3E0);
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: notify['isUnread'] ? bgColor.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: notify['isUnread'] ? iconColor.withValues(alpha: 0.1) : const Color(0xFFF1F1F1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notify['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    if (notify['isUnread'])
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notify['message'],
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textGray.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  notify['time'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
