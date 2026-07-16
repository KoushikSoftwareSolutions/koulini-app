import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/language_card.dart';


import 'onboarding_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;
  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English';
  final FlutterTts _flutterTts = FlutterTts();
  bool _hasSpoken = false;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'char': 'A'},
    {'name': 'Telugu', 'char': 'అ'},
    {'name': 'Hindi', 'char': 'अ'},
    {'name': 'Tamil', 'char': 'அ'},
    {'name': 'Malayalam', 'char': 'അ'},
    {'name': 'Kannada', 'char': 'ಅ'},
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.isFromSettings) {
      _speakWelcome();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakWelcome() async {
    if (_hasSpoken) return;
    _hasSpoken = true;
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.speak("Welcome to Koulini. Please select your language.");
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.isFromSettings 
        ? AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 22.sp),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Change Language',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          )
        : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.isFromSettings) SizedBox(height: 60.h),
                // Logo
                if (!widget.isFromSettings)
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'k',
                          style: GoogleFonts.poppins(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!widget.isFromSettings) SizedBox(height: 16.h),
                // Title
                if (!widget.isFromSettings)
                  Text(
                    'Koulini',
                    style: AppTextStyles.logoTitle,
                  ),

                if (!widget.isFromSettings) SizedBox(height: 60.h),
                // Main Question
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Which Language do you speak?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.questionTitle,
                  ),
                ),
                SizedBox(height: 40.h),
                // Language List
                Column(
                  children: List.generate(languages.length, (index) {
                    final lang = languages[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: LanguageCard(
                        character: lang['char']!,
                        languageName: lang['name']!,
                        isSelected: selectedLanguage == lang['name'],
                        onTap: () {
                          setState(() {
                            selectedLanguage = lang['name']!;
                          });
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedLanguage.isEmpty
                ? SizedBox(height: 56.h)
                : ElevatedButton(
                    onPressed: () {
                      final codeMap = {
                        'English': 'en',
                        'Telugu': 'te',
                        'Hindi': 'hi',
                        'Tamil': 'ta',
                        'Malayalam': 'ml',
                        'Kannada': 'kn',
                      };
                      final langCode = codeMap[selectedLanguage] ?? 'en';
                      Provider.of<AuthState>(context, listen: false).setLanguage(langCode);

                      if (widget.isFromSettings) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language updated to $selectedLanguage'),
                            backgroundColor: AppColors.primaryPurple,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      }
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
                      widget.isFromSettings ? 'Update Language' : 'Continue in $selectedLanguage',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
