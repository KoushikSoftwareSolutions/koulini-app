import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/role_card.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/enums/user_role.dart';
import 'worker_registration_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole selectedRole = UserRole.worker; // Default based on design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.primaryPurple.withValues(alpha: 0.03),
              AppColors.primaryPurple.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
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
                                  'k',
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
                      isSelected: selectedRole == UserRole.worker,
                      onTap: () {
                        setState(() => selectedRole = UserRole.worker);
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Jobs Card (Replaces Employer Card)
                    RoleCard(
                      title: 'Jobs',
                      subtitle: 'Find jobs mentioned in the app are priest, teacher, nurse, trainer, pharmacist and warden.\n\nMore jobs will be added in future as per majority.',
                      initial: 'J',
                      isSelected: selectedRole == UserRole.job,
                      onTap: () {
                        setState(() => selectedRole = UserRole.job);
                      },
                    ),
                    const Spacer(),
                    

                    
                    // Dynamic Bottom Button
                    ElevatedButton(
                      onPressed: () {
                        // Store the selected role globally
                        Provider.of<AuthState>(context, listen: false).setPendingRole(selectedRole);

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
                        selectedRole.content.roleSelectionContinueButton,
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
      ),
    );
  }
}
