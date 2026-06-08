import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_state.dart';
import 'features/auth/screens/language_selection_screen.dart';
import 'main_wrapper.dart';
import 'features/employer/layout/employer_main_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Track the user role globally ('Worker' or 'Employer')
  static String userRole = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
              home: const AppStartupWrapper(),
            );
          },
        );
      },
    );
  }
}

class AppStartupWrapper extends StatefulWidget {
  const AppStartupWrapper({super.key});

  @override
  State<AppStartupWrapper> createState() => _AppStartupWrapperState();
}

class _AppStartupWrapperState extends State<AppStartupWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    try {
      await authState.tryRestoreSession();
    } catch (e) {
      debugPrint('Session restoration error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA167F5)),
          ),
        ),
      );
    }

    final authState = Provider.of<AuthState>(context);
    if (authState.isLoggedIn) {
      MyApp.userRole = authState.role ?? '';
      if (authState.role == 'Employer') {
        return const EmployerMainWrapper();
      } else {
        return const MainWrapper();
      }
    }

    return const LanguageSelectionScreen();
  }
}
