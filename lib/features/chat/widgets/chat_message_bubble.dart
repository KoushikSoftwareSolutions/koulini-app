import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 0.7.sw),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryPurple : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: isMe ? Radius.circular(20.r) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : Radius.circular(20.r),
                  ),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: isMe ? Colors.white : AppColors.textBlack,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColors.textLightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
