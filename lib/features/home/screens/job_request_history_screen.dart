import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class JobRequestHistoryScreen extends StatefulWidget {
  const JobRequestHistoryScreen({super.key});

  @override
  State<JobRequestHistoryScreen> createState() => _JobRequestHistoryScreenState();
}

class _JobRequestHistoryScreenState extends State<JobRequestHistoryScreen> {
  final List<String> _filters = ['All', 'Accepted', 'Declined', 'Expired'];
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _historyData = [
    {
      'employer': 'Reddy Builders',
      'title': 'Masonry Work',
      'date': 'Oct 12, 2023',
      'status': 'Accepted',
      'wage': '₹750/day',
      'avatar': 'R',
    },
    {
      'employer': 'Lalitha Stores',
      'title': 'Shop Assistant',
      'date': 'Oct 05, 2023',
      'status': 'Declined',
      'wage': '₹400/day',
      'avatar': 'L',
    },
    {
      'employer': 'Durga Constructions',
      'title': 'Helper',
      'date': 'Sep 28, 2023',
      'status': 'Expired',
      'wage': '₹500/day',
      'avatar': 'D',
    },
    {
      'employer': 'Green Farms',
      'title': 'Farm Labour',
      'date': 'Sep 20, 2023',
      'status': 'Accepted',
      'wage': '₹450/day',
      'avatar': 'G',
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilterIndex == 0) return _historyData;
    final filter = _filters[_selectedFilterIndex];
    return _historyData.where((item) => item['status'] == filter).toList();
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
          'Request History',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              itemCount: _filteredHistory.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = _filteredHistory[index];
                return _buildHistoryCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(top: 8.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    Color statusColor;
    Color bgColor;

    switch (item['status']) {
      case 'Accepted':
        statusColor = const Color(0xFF22C55E);
        bgColor = const Color(0xFFF0FDF4);
        break;
      case 'Declined':
        statusColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
        break;
      default:
        statusColor = AppColors.textLightGray;
        bgColor = const Color(0xFFF3F4F6);
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF3F4F6)),
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
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            child: Text(
              item['avatar'],
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['employer'],
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  item['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['date'],
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: AppColors.textLightGray,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  item['status'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
