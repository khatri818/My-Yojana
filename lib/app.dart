
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'common/app_providers.dart';
import 'core/constant/app_themes.dart';
import 'features/auth/presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyYojana',
            theme: AppThemes.appTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
