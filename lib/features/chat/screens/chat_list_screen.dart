import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'Manoj Kumar',
      'lastMessage': 'Sure sir, I will be there by 8 AM.',
      'time': '10:40 AM',
      'avatar': 'https://i.pravatar.cc/150?u=manoj',
      'unread': 0,
    },
    {
      'name': 'Suresh V.',
      'lastMessage': 'I have started the painting work.',
      'time': '09:15 AM',
      'avatar': 'https://i.pravatar.cc/150?u=suresh',
      'unread': 2,
    },
    {
      'name': 'Ramesh P.',
      'lastMessage': 'Can we discuss the schedule?',
      'time': 'Yesterday',
      'avatar': 'https://i.pravatar.cc/150?u=ramesh',
      'unread': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search_rounded, color: AppColors.textLightGray),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _chats.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              separatorBuilder: (context, index) => Divider(height: 1, color: const Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(worker: chat),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  leading: Stack(
                    children: [
                      PremiumImage(
                        imageUrl: chat['avatar'],
                        width: 56.r,
                        height: 56.r,
                        isAvatar: true,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    chat['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  subtitle: Text(
                    chat['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: chat['unread'] > 0 ? AppColors.textBlack : AppColors.textLightGray,
                      fontWeight: chat['unread'] > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'],
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.textLightGray,
                        ),
                      ),
                      if (chat['unread'] > 0) ...[
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
