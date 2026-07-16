import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'role_selection_screen.dart';
import '../../../main_wrapper.dart';
import '../../employer/layout/employer_main_wrapper.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final FocusNode _confirmPinFocusNode = FocusNode();
  
  bool _isConfirmStep = false;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _pinFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  bool _isWeakPin(String pin) {
    if (RegExp(r'^(\d)\1{5}$').hasMatch(pin)) return true;
    final weakPins = ['123456', '654321', '012345', '543210', '121212', '131313'];
    return weakPins.contains(pin);
  }

  void _handlePinCompleted(String pin) {
    if (_isWeakPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a stronger PIN. Avoid sequential or repeated numbers.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _pinController.clear();
      _pinFocusNode.requestFocus();
      return;
    }
    
    setState(() {
      _pin = pin;
      _isConfirmStep = true;
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      _confirmPinFocusNode.requestFocus();
    });
  }

  Future<void> _handleConfirmCompleted(String confirmPin) async {
    if (confirmPin != _pin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match. Try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _confirmPinController.clear();
      _confirmPinFocusNode.requestFocus();
      return;
    }

    final authState = Provider.of<AuthState>(context, listen: false);
    final success = await authState.setPin(pin: _pin, confirmPin: confirmPin);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Navigate based on registration status
      if (authState.isRegistered) {
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
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const RoleSelectionScreen(),
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
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error ?? 'Failed to set PIN.'),
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Secure Your Account',
            style: GoogleFonts.poppins(
              color: AppColors.textBlack,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
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
                        _isConfirmStep ? 'Confirm your PIN' : 'Create a 6-digit PIN',
                        style: AppTextStyles.questionTitle.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _isConfirmStep 
                            ? 'Please re-enter your PIN to confirm'
                            : 'Create a PIN for faster login next time.',
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.textGray.withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isConfirmStep
                              ? Pinput(
                                  key: const ValueKey('confirm'),
                                  length: 6,
                                  controller: _confirmPinController,
                                  focusNode: _confirmPinFocusNode,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  obscureText: true,
                                  obscuringCharacter: '●',
                                  showCursor: true,
                                  onCompleted: _handleConfirmCompleted,
                                )
                              : Pinput(
                                  key: const ValueKey('create'),
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
                      ),
                      
                      if (_isConfirmStep) ...[
                        SizedBox(height: 24.h),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmStep = false;
                                _pin = '';
                                _confirmPinController.clear();
                                _pinController.clear();
                              });
                              _pinFocusNode.requestFocus();
                            },
                            child: Text(
                              'Change PIN',
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      if (authState.isLoading)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 32.h),
                            child: const CircularProgressIndicator(color: AppColors.primaryPurple),
                          ),
                        ),
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
