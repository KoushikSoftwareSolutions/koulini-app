import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../screens/employer_home_screen.dart';
import '../screens/employer_profile_screen.dart';
import '../screens/active_workers_screen.dart';

class EmployerMainWrapper extends StatefulWidget {
  const EmployerMainWrapper({super.key});

  @override
  State<EmployerMainWrapper> createState() => _EmployerMainWrapperState();
}

class _EmployerMainWrapperState extends State<EmployerMainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EmployerHomeScreen(),
    const ActiveWorkersScreen(),
    const EmployerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryPurple,
          unselectedItemColor: AppColors.textLightGray,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'home page',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.engineering_outlined),
              activeIcon: Icon(Icons.engineering_rounded),
              label: 'active',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              activeIcon: Icon(Icons.business_rounded),
              label: 'business profile',
            ),
          ],
        ),
      ),
    );
  }
}
