import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../main_wrapper.dart';
import '../../../../main.dart';

class ApplicationSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ApplicationSuccessScreen({
    super.key,
    required this.job,
  });

  @override
  State<ApplicationSuccessScreen> createState() => _ApplicationSuccessScreenState();
}

class _ApplicationSuccessScreenState extends State<ApplicationSuccessScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Confetti logic
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _confettiController.play();
    });

    // Entry animation logic
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    
    _fadeAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeIn);
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSuccessHeader(),
                      SizedBox(height: 48.h),
                      _buildDetailCard(),
                      const Spacer(),
                      _buildActionButtons(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Confetti blast from the center
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFF8B5CF6),
              Color(0xFF4CAF50),
              Color(0xFFFF9800),
              Color(0xFF2196F3),
            ],
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 40.sp,
            color: const Color(0xFF2E7D32),
          ),
        ),
        SizedBox(height: 32.h),
        Text(
          'Application Submitted!',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            MyApp.userRole == 'Worker'
                ? 'Your application for "${widget.job['title']}" has been sent. The business owner will review it soon.'
                : 'Your application for "${widget.job['title']}" has been sent. The employer will review it soon.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(MyApp.userRole == 'Worker' ? 'Work' : 'Job', widget.job['title'] ?? 'Mason Required'),
          _detailDivider(),
          _buildDetailRow(MyApp.userRole == 'Worker' ? 'Business Owner' : 'Employer', widget.job['company'] ?? 'Vijay Constructions'),
          _detailDivider(),
          _buildDetailRow('Pay', 'Rs. ${widget.job['salary'] ?? '700/day'}'),
          _detailDivider(),
          _buildDetailRow('Location', widget.job['location'] ?? 'Machilipatnam'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textLightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        color: AppColors.borderGray.withOpacity(0.05),
        thickness: 1,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainWrapper()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 8,
            shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
          ),
          child: Text(
            MyApp.userRole == 'Worker' ? 'Find More Work' : 'Find More Jobs',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainWrapper(initialIndex: 1),
              ),
              (route) => false,
            );
          },
          style: TextButton.styleFrom(
            minimumSize: Size(double.infinity, 56.h),
          ),
          child: Text(
            'View My Applications',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }
}
