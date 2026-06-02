import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/role_card.dart';
import 'worker_registration_screen.dart';
import 'employer_registration_screen.dart';
import '../../../../main.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = 'Worker'; // Default based on design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    // Logo and Title (Hero Animation)
                    Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: 'app_logo',
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'K',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Koulini',
                            style: AppTextStyles.logoTitle.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Question
                    Text(
                      'I am a....',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Choose your role. You can change this Later.',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Worker Card
                    RoleCard(
                      title: 'Worker',
                      subtitle: 'Find daily wage work, manual labour, shop keeper, construction site work, drivers and other works near your area.',
                      initial: 'W',
                      isSelected: selectedRole == 'Worker',
                      onTap: () {
                        setState(() => selectedRole = 'Worker');
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Jobs Card (Replaces Employer Card)
                    RoleCard(
                      title: 'Jobs',
                      subtitle: 'Find jobs mentioned in the app are priest, teacher, nurse, trainer, pharmacist and warden.\n\nMore jobs will be added in future as per majority.',
                      initial: 'J',
                      isSelected: selectedRole == 'Jobs',
                      onTap: () {
                        setState(() => selectedRole = 'Jobs');
                      },
                    ),
                    const Spacer(),
                    
                    // Business / Employer Link (Frosted button styled perfectly for the circled area)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Sets role globally to Employer and navigates directly to EmployerRegistrationScreen
                          MyApp.userRole = 'Employer';
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const EmployerRegistrationScreen(),
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
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.15)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.business_center_rounded, size: 18.sp, color: AppColors.primaryPurple),
                            SizedBox(width: 8.w),
                            Text(
                              'Are you a Business or Employer?',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    
                    // Dynamic Bottom Button
                    ElevatedButton(
                      onPressed: () {
                        // Store the selected role globally
                        MyApp.userRole = selectedRole;

                        Widget targetScreen = const WorkerRegistrationScreen();

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
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
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 6,
                        shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        'Continue as $selectedRole',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
