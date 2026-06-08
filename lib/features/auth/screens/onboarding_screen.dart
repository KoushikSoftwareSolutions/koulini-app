import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/glass_box.dart';
import '../widgets/onboarding_feature_item.dart';
import 'sign_in_screen.dart';
import '../../../../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isWorker = true; // Dynamic toggle between worker and employer

  final List<Map<String, dynamic>> workerFeatures = [
    {
      'icon': Icons.home_work_rounded,
      'title': 'Work near your area',
      'subtitle': 'Find all types of work like Shopkeepers, manual labour, drivers, etc. In your village, mandal, district and state and get a work easily by applying.',
    },
    {
      'icon': Icons.school_rounded,
      'title': 'jobs near your area',
      'subtitle': 'Find jobs in your area. Available jobs are teachers, poojari or priests, trainers, nurses, pharmacists and wardens.',
    },
    {
      'icon': Icons.verified_user_rounded,
      'title': 'Verified workers and employees only',
      'subtitle': 'OTP-Verified-no fake account',
    },
    {
      'icon': Icons.groups_rounded,
      'title': 'Community growth',
      'subtitle': 'Grow together with your area community.',
    },
  ];

  final List<Map<String, dynamic>> employerFeatures = [
    {
      'icon': Icons.groups_rounded,
      'title': 'Workers near your area',
      'subtitle': 'Hire workers for your farm, shop, construction site, etc in your village, mandal, district and state and find a worker easily by posting.',
    },
    {
      'icon': Icons.people_outline_rounded,
      'title': 'employees near your area',
      'subtitle': 'Find employees in your area if needed and availability of posting jobs are teachers, poojari or priests, trainers, nurses, pharmacists and wardens.',
    },
    {
      'icon': Icons.verified_rounded,
      'title': 'Verified business profile and postings',
      'subtitle': 'OTP-Verified-no fake account and postings.',
    },
    {
      'icon': Icons.groups_rounded,
      'title': 'Community growth',
      'subtitle': 'Grow together with your area community.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFeatures = _isWorker ? workerFeatures : employerFeatures;
    final backgroundAsset = _isWorker 
        ? 'assets/images/worker_onboarding_bg.png' 
        : 'assets/images/employer_onboarding_bg.png';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image (Smooth cross-fade animation when toggled)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                backgroundAsset,
                key: ValueKey<String>(backgroundAsset),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Stack(
              children: [
                // Top Logo Box (Positioned at the top, perfectly sized)
                Positioned(
                  top: 16.h,
                  left: 24.w,
                  right: 24.w,
                  child: Center(
                    child: Hero(
                      tag: 'app_logo',
                      child: GlassBox(
                        blur: 20,
                        opacity: 0.15,
                        child: Container(
                          width: 140.w,
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 34.w,
                                  height: 34.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPurple,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'K',
                                      style: GoogleFonts.poppins(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Koulini',
                                  style: AppTextStyles.logoTitle.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Frosted Glass Bottom Content Card (Compact to showcase backgrounds)
                Positioned(
                  bottom: 16.h,
                  left: 24.w,
                  right: 24.w,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88), // Frosted glass look to let background peek through
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sliding Pill Role Selector Toggle (horizontal slide animation)
                        Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: const Color(0x1F767680), // Premium semi-transparent base
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double width = constraints.maxWidth;
                              return Stack(
                                children: [
                                  // Animated white slider background
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOutCubic,
                                    left: _isWorker ? 3.w : (width / 2) + 1.w,
                                    width: (width / 2) - 4.w,
                                    top: 3.h,
                                    bottom: 3.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.08),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Static row containing tap detectors and text labels
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        // Worker Selector
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (!_isWorker) {
                                                setState(() {
                                                  _isWorker = true;
                                                  _currentPage = 0;
                                                });
                                                _pageController.jumpToPage(0);
                                              }
                                            },
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 200),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: _isWorker ? AppColors.primaryPurple : AppColors.textGray,
                                                ),
                                                child: const Text('Find Work'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Employer Selector
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (_isWorker) {
                                                setState(() {
                                                  _isWorker = false;
                                                  _currentPage = 0;
                                                });
                                                _pageController.jumpToPage(0);
                                              }
                                            },
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 200),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: !_isWorker ? AppColors.primaryPurple : AppColors.textGray,
                                                ),
                                                child: const Text('Hire Workers'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        
                        // Dynamic Carousel (Reduced height to avoid layout overflows)
                        SizedBox(
                          height: 112.h,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: currentFeatures.length,
                            itemBuilder: (context, index) {
                              return OnboardingFeatureItem(
                                icon: currentFeatures[index]['icon'],
                                title: currentFeatures[index]['title'],
                                subtitle: currentFeatures[index]['subtitle'],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                        
                        // Indicators & Button row to save vertical space
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Indicators on the left
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(currentFeatures.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  height: 6.h,
                                  width: _currentPage == index ? 18.w : 6.w,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index 
                                        ? AppColors.primaryPurple 
                                        : AppColors.primaryPurple.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(3.r),
                                  ),
                                );
                              }),
                            ),
                            
                            // Small Login Button on the right (Highly optimized)
                            ElevatedButton(
                              onPressed: () {
                                MyApp.userRole = _isWorker ? 'Worker' : 'Employer';
                                
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
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
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPurple,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 4,
                                shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Login Now',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Icon(Icons.arrow_forward_rounded, size: 16.sp),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
