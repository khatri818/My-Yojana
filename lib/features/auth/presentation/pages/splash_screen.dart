import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../constant/image_resource.dart';
import '../../../../core/utils/log_utility.dart';
import '../../../home/presentation/manager/scheme_manger.dart';
import '../../../home/presentation/pages/bottom_navigation_page.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../manager/auth_manger.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {

    await Future.delayed(const Duration(milliseconds: 1500));

    // Check user session
    if (mounted) {
      LogUtility.info('Inside Mounted');

      final authManager = context.read<AuthManager>();
      final userManager = context.read<UserManager>();
      final schemeManager = context.read<SchemeManager>();

      final userSession = await authManager.checkUser();

      if (!mounted) return;
      if (userSession != null) {
        if (userSession.isNewUser) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          LogUtility.info('USER : THIS APP HAS A USER');
          await userManager.getUser(userSession.token);
          await schemeManager.getScheme();
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
      } else {
        LogUtility.info('Not in Mounted');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Animate(
              effects: const [
                FadeEffect(duration: Duration(milliseconds: 900)),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageResource.logo,
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
