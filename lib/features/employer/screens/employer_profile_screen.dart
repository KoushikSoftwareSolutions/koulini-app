import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/screens/sign_in_screen.dart';
import 'edit_business_screen.dart';
import 'help_faq_screen.dart';
import 'hiring_history_screen.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Business Settings',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _buildBusinessHeaderCard(),
              SizedBox(height: 24.h),
              _buildSectionTitle('Business Profile'),
              _buildSettingsGroup([
                _SettingsItem(
                  icon: Icons.edit_outlined,
                  title: 'Edit Business Details',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditBusinessScreen())),
                ),
                _SettingsItem(
                  icon: Icons.history_rounded,
                  title: 'Hiring History',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HiringHistoryScreen())),
                ),
                _SettingsItem(
                  icon: Icons.notifications_active_outlined,
                  title: 'Manage Notifications',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification settings updated')),
                    );
                  },
                ),
                _SettingsItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change PIN / Password',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN reset link sent to your registered number')),
                    );
                  },
                ),
                _SettingsItem(
                  icon: Icons.translate_rounded,
                  title: 'Language ($_selectedLanguage)',
                  onTap: () => _showLanguageSheet(),
                ),
              ]),
              SizedBox(height: 24.h),
              _buildSectionTitle('Support'),
              _buildSettingsGroup([
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpFaqScreen())),
                ),
                _SettingsItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Contact Us',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting to helpdesk support...')),
                    );
                  },
                ),
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About & Privacy',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'KaamKaro',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 KaamKaro. All rights reserved.',
                    );
                  },
                ),
              ]),
              SizedBox(height: 48.h),
              _buildLogoutButton(context),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessHeaderCard() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditBusinessScreen())),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
              child: Icon(Icons.business_rounded, color: AppColors.primaryPurple, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vijay Constructions',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    'Vijay Kumar (Owner)',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  Text(
                    'Employer Account',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 24.sp, color: AppColors.textLightGray),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              _buildListTile(item),
              if (index < items.length - 1)
                Padding(
                  padding: EdgeInsets.only(left: 56.w),
                  child: Divider(height: 1, color: const Color(0xFFF1F1F1)),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildListTile(_SettingsItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(item.icon, size: 20.sp, color: AppColors.textBlack),
            ),
            SizedBox(width: 16.w),
            Text(
              item.title,
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, size: 20.sp, color: AppColors.textLightGray),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: () {
          // Clear stack and go to sign in
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Language',
              style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textBlack),
            ),
            SizedBox(height: 24.h),
            _buildLanguageOption('English'),
            _buildLanguageOption('తెలుగు (Telugu)'),
            _buildLanguageOption('हिन्दी (Hindi)'),
            _buildLanguageOption('தமிழ் (Tamil)'),
            _buildLanguageOption('മലയാളം (Malayalam)'),
            _buildLanguageOption('ಕನ್ನಡ (Kannada)'),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String lang) {
    final isSelected = _selectedLanguage == lang;
    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = lang);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryPurple : AppColors.textBlack,
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: AppColors.primaryPurple, size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _SettingsItem({required this.icon, required this.title, required this.onTap});
}
