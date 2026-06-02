import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/confetti_background.dart';
import '../widgets/success_profile_card.dart';
import '../../../../main_wrapper.dart';
import '../../employer/layout/employer_main_wrapper.dart';
import '../../../../main.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final bool isEmployer;
  const RegistrationSuccessScreen({
    super.key,
    this.isEmployer = false,
  });

  @override
  State<RegistrationSuccessScreen> createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    // Start the blast with a small delay for smoother transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const ConfettiBackground(),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 80.h, left: 24.w, right: 24.w),
                      child: Column(
                        children: [
                          Text(
                            'You are all set!',
                            style: AppTextStyles.questionTitle.copyWith(
                              fontSize: 28.sp,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.isEmployer 
                              ? 'Your Business profile is ready. Start hiring talented workers/employees near you!'
                              : (isWorker
                                  ? 'Your KaamKaro profile is ready. Start exploring work near you!'
                                  : 'Your KaamKaro profile is ready. Start exploring jobs near you!'),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.subtitle.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textGray.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          const SuccessProfileCard(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h), 
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What happens next?',
                        style: AppTextStyles.questionTitle.copyWith(
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildStepItem(
                        index: '1',
                        color: const Color(0xFF4CAF50),
                        title: widget.isEmployer 
                            ? 'Post your first work/job' 
                            : (isWorker 
                                ? 'Business owners will find your profile' 
                                : 'Employers will find your profile'),
                        subtitle: widget.isEmployer ? 'Describe your requirements' : 'Your skills are now searchable',
                      ),
                      SizedBox(height: 24.h),
                      _buildStepItem(
                        index: '2',
                        color: const Color(0xFFFF9800),
                        title: widget.isEmployer 
                            ? 'Review applicants' 
                            : (isWorker ? 'Get work alerts' : 'Get job alerts'),
                        subtitle: widget.isEmployer 
                            ? 'Check profiles and ratings' 
                            : (isWorker ? "We'll notify you of matching work" : "We'll notify you of matching jobs"),
                      ),
                      SizedBox(height: 24.h),
                      _buildStepItem(
                        index: '3',
                        color: const Color(0xFF2196F3),
                        title: widget.isEmployer ? 'Communicate and Hire' : 'Apply in one tap',
                        subtitle: widget.isEmployer ? 'Chat directly with workers/employees' : 'No lengthy forms needed',
                      ),
                      SizedBox(height: 48.h),
                      
                      ElevatedButton(
                        onPressed: () {
                          Widget target = widget.isEmployer 
                            ? const EmployerMainWrapper()
                            : const MainWrapper();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => target),
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
                          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
                        ),
                        child: Text(
                          widget.isEmployer 
                              ? 'Start Hiring' 
                              : (isWorker ? 'Start Finding Work' : 'Start Finding Jobs'),
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Confetti Widget anchored to top center
          ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive, // All directions
            shouldLoop: false,
            colors: const [
              Color(0xFF4CAF50), // Green
              Color(0xFFFF9800), // Orange
              Color(0xFF2196F3), // Blue
              Color(0xFFF44336), // Red
              Color(0xFF9C27B0), // Purple
            ],
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String index,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              index,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textLightGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
