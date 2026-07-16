import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'otp_verification_screen.dart';
import '../../../main_wrapper.dart';
import '../../employer/layout/employer_main_wrapper.dart';

class PinLoginScreen extends StatefulWidget {
  final String phoneNumber;

  const PinLoginScreen({super.key, required this.phoneNumber});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isLoadingOtp = false;

  @override
  void initState() {
    super.initState();
    _pinFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePinCompleted(String pin) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final success = await authState.loginWithPin(phone: widget.phoneNumber, pin: pin);

    if (success && mounted) {
      if (authState.role == 'Employer') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const EmployerMainWrapper(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainWrapper(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
          (route) => false,
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error ?? 'Invalid PIN.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _pinController.clear();
      _pinFocusNode.requestFocus();
    }
  }

  Future<void> _handleLoginWithOtp() async {
    setState(() => _isLoadingOtp = true);

    final authState = Provider.of<AuthState>(context, listen: false);
    final role = authState.pendingRole?.value ?? 'Worker';

    final result = await AuthService.instance.sendOtp(
      phone: widget.phoneNumber,
      role: role,
      language: authState.language ?? 'en',
    );

    setState(() => _isLoadingOtp = false);

    if (result.success && mounted) {
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
            OtpVerificationScreen(phoneNumber: widget.phoneNumber),
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
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Failed to send OTP.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: AppTextStyles.logoTitle.copyWith(
        fontSize: 24.sp,
        color: AppColors.textBlack,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.textBlack, width: 1.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack, size: 24.sp),
          onPressed: () => Navigator.pop(context),
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
                    SizedBox(height: 32.h),
                    Text(
                      'Enter your PIN',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Welcome back! Enter your 6-digit PIN to login securely.',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        obscureText: true,
                        obscuringCharacter: '●',
                        showCursor: true,
                        onCompleted: _handlePinCompleted,
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    if (authState.isLoading)
                      const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryPurple),
                      )
                    else ...[
                      Center(
                        child: TextButton(
                          onPressed: _handleLoginWithOtp,
                          child: Text(
                            'Forgot PIN?',
                            style: AppTextStyles.subtitle.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ),
                      
                      Center(
                        child: TextButton(
                          onPressed: _isLoadingOtp ? null : _handleLoginWithOtp,
                          child: _isLoadingOtp 
                            ? SizedBox(
                                height: 16.h, 
                                width: 16.h, 
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'Login using OTP instead',
                                style: AppTextStyles.subtitle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textGray,
                                ),
                              ),
                        ),
                      ),
                    ],
                    
                    const Spacer(),
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
