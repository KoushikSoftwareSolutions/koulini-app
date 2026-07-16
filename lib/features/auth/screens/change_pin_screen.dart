import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  
  final FocusNode _currentPinFocusNode = FocusNode();
  final FocusNode _newPinFocusNode = FocusNode();
  final FocusNode _confirmPinFocusNode = FocusNode();
  
  int _step = 0; // 0: Current, 1: New, 2: Confirm
  String _currentPin = '';
  String _newPin = '';

  @override
  void initState() {
    super.initState();
    _currentPinFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _currentPinFocusNode.dispose();
    _newPinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  bool _isWeakPin(String pin) {
    if (RegExp(r'^(\d)\1{5}$').hasMatch(pin)) return true;
    final weakPins = ['123456', '654321', '012345', '543210', '121212', '131313'];
    return weakPins.contains(pin);
  }

  void _handleCurrentPinCompleted(String pin) {
    setState(() {
      _currentPin = pin;
      _step = 1;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _newPinFocusNode.requestFocus();
    });
  }

  void _handleNewPinCompleted(String pin) {
    if (_isWeakPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a stronger PIN. Avoid sequential or repeated numbers.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _newPinController.clear();
      _newPinFocusNode.requestFocus();
      return;
    }
    
    if (pin == _currentPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New PIN must be different from current PIN.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _newPinController.clear();
      _newPinFocusNode.requestFocus();
      return;
    }
    
    setState(() {
      _newPin = pin;
      _step = 2;
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      _confirmPinFocusNode.requestFocus();
    });
  }

  Future<void> _handleConfirmCompleted(String confirmPin) async {
    if (confirmPin != _newPin) {
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
    final success = await authState.changePin(
      currentPin: _currentPin, 
      newPin: _newPin, 
      confirmPin: confirmPin,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // Go back to settings
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error ?? 'Failed to update PIN.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Reset back to current PIN step
      setState(() {
        _step = 0;
        _currentPin = '';
        _newPin = '';
        _currentPinController.clear();
        _newPinController.clear();
        _confirmPinController.clear();
      });
      _currentPinFocusNode.requestFocus();
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
        title: Text(
          'Change PIN',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
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
                    SizedBox(height: 32.h),
                    Text(
                      _step == 0 
                        ? 'Enter Current PIN' 
                        : _step == 1 
                          ? 'Enter New PIN' 
                          : 'Confirm New PIN',
                      style: AppTextStyles.questionTitle.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _step == 0 
                        ? 'Verify your identity to change PIN' 
                        : _step == 1 
                          ? 'Create a new 6-digit PIN' 
                          : 'Re-enter your new PIN',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textGray.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _step == 0
                          ? Pinput(
                              key: const ValueKey('current'),
                              length: 6,
                              controller: _currentPinController,
                              focusNode: _currentPinFocusNode,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              obscureText: true,
                              obscuringCharacter: '●',
                              showCursor: true,
                              onCompleted: _handleCurrentPinCompleted,
                            )
                          : _step == 1
                            ? Pinput(
                                key: const ValueKey('new'),
                                length: 6,
                                controller: _newPinController,
                                focusNode: _newPinFocusNode,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                obscureText: true,
                                obscuringCharacter: '●',
                                showCursor: true,
                                onCompleted: _handleNewPinCompleted,
                              )
                            : Pinput(
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
                              ),
                      ),
                    ),
                    
                    if (_step > 0) ...[
                      SizedBox(height: 24.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _step = 0;
                              _currentPin = '';
                              _newPin = '';
                              _currentPinController.clear();
                              _newPinController.clear();
                              _confirmPinController.clear();
                            });
                            _currentPinFocusNode.requestFocus();
                          },
                          child: Text(
                            'Start Over',
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
    );
  }
}
