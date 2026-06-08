import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/phone_input_field.dart';
import 'otp_verification_screen.dart';
import '../../../../main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() => _isLoading = true);

    final authState = Provider.of<AuthState>(context, listen: false);
    // Sync the global userRole to AuthState
    authState.role = MyApp.userRole;

    final result = await AuthService.instance.sendOtp(
      phone: phone,
      role: authState.role ?? 'Worker',
      language: authState.language ?? 'en',
    );

    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        // If developer/test mode returns devOtp, we can print or show a toast/dialog for developer ease
        final devOtp = result.data?['devOtp'];
        if (devOtp != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dev Mode OTP: $devOtp'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 8),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              OtpVerificationScreen(phoneNumber: phone),
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
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Failed to send OTP. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 24.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
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
                    SizedBox(height: 20.h),
                    Text(
                      'Sign In',
                      style: AppTextStyles.logoTitle.copyWith(
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'What is your phone number?',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'We will send a 6-digit OTP. No password needed.',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // Phone Input
                    PhoneInputField(
                      controller: _phoneController,
                      onChanged: (val) {
                        setState(() {
                          // Validation: Exactly 10 digits AND starts with 6, 7, 8, or 9
                          final trimmed = val.trim();
                          _isButtonEnabled = trimmed.length == 10 && 
                              ['6', '7', '8', '9'].contains(trimmed[0]);
                        });
                      },
                    ),
                    SizedBox(height: 32.h),
                    // Send OTP Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: (_isButtonEnabled && !_isLoading) ? _handleSendOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          disabledBackgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                          minimumSize: Size(double.infinity, 56.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: _isButtonEnabled ? 8 : 0,
                          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Send OTP',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: 40.h),
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
