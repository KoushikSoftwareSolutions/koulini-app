import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/screens/language_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Track the user role globally ('Worker' or 'Employer')
  static String userRole = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen is wider than 500 logical pixels (tablet, web, desktop),
        // we set the design size to the actual screen size so elements (sp, w, h)
        // scale 1:1 and look normal instead of becoming giant.
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final Size designSize = width > 500 
            ? Size(width, height) 
            : const Size(390, 844);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Koulini',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA167F5)),
                useMaterial3: true,
              ),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('te'),
                Locale('hi'),
                Locale('ta'),
                Locale('ml'),
                Locale('kn'),
              ],
              home: const LanguageSelectionScreen(),
            );
          },
        );
      },
    );
  }
}
