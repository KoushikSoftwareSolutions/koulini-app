import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_image.dart';
import 'my_profile_screen.dart';
import '../../../../main.dart';

import 'edit_profile_screen.dart';
import 'language_selection_screen.dart';
import 'worker_help_faq_screen.dart';
import 'my_status_screen.dart';
import '../../home/screens/job_search_screen.dart';
import '../../employer/screens/hire_workers_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
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
              _buildUserHeaderCard(context),
              SizedBox(height: 24.h),
              _buildSectionTitle('Account'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.edit_outlined, 
                  title: 'Edit Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.notifications_active_outlined, 
                  title: 'My Status',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyStatusScreen()),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.translate_rounded, 
                  title: 'Language',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LanguageSelectionScreen(isFromSettings: true)),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.thumb_up_alt_outlined, 
                  title: MyApp.userRole == 'Worker' ? 'Work Recommendation' : 'Job Recommendation',
                  onTap: () {
                    if (MyApp.userRole == 'Worker') {
                      final skill = profile?['primarySkill'] ?? 'Mason';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobSearchScreen(initialQuery: skill),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HireWorkersScreen(),
                        ),
                      );
                    }
                  },
                ),
              ]),
              SizedBox(height: 24.h),
              _buildSectionTitle('Support'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.help_outline_rounded, 
                  title: 'Help & FAQ',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkerHelpFaqScreen()),
                  ),
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

  Widget _buildUserHeaderCard(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final profile = authState.profile;
    final String name = profile?['name'] ?? profile?['ownerName'] ?? 'User';
    final String phone = profile?['phone'] ?? authState.pendingPhone ?? '+91 XXXXX XXXXX';
    final avatar = (profile?['profilePhoto'] != null && profile!['profilePhoto'].toString().isNotEmpty)
        ? profile['profilePhoto'].toString()
        : 'https://i.pravatar.cc/150?u=${profile?['_id'] ?? name}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MyProfileScreen(),
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
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            PremiumImage(
              imageUrl: avatar,
              width: 60.r,
              height: 60.r,
              isAvatar: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    phone,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  Text(
                    MyApp.userRole == 'Worker' ? 'Workers account' : 'Employee account',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1BAB4F),
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

  Widget _buildSettingsGroup(BuildContext context, List<_SettingsItem> items) {
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
              _buildListTile(context, item),
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

  Widget _buildListTile(BuildContext context, _SettingsItem item) {
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
        onPressed: () async {
          final authState = Provider.of<AuthState>(context, listen: false);
          await authState.signOut();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyApp()),
              (route) => false,
            );
          }
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
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  _SettingsItem({required this.icon, required this.title, this.onTap});
}
