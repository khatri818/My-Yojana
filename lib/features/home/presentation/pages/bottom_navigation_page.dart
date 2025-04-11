import 'package:flutter/material.dart';
import 'package:my_yojana/features/home/presentation/pages/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../constant/image_resource.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../manager/bottom_nav_manager.dart';
import '../manager/scheme_manger.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUser();
    });
  }

  Future<void> _fetchUser() async {
    try {
      final authManager = context.read<AuthManager>();
      final userSession = await authManager.checkUser();

      if (userSession != null && mounted) {
        final userManager = context.read<UserManager>();
        final schemeManager = context.read<SchemeManager>();

        await userManager.getUser(userSession.token);
        await schemeManager.getScheme(); // Optional: only if needed
      } else {
        debugPrint('User session is null');
        // Optionally redirect to login or show message
      }
    } catch (e, stack) {
      debugPrint('Error fetching user: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white.withOpacity(0),
        title: Image.asset(ImageResource.bannerLogo, height: 45),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: const [
              HomePage(),
              HomePage(),
              HomePage(),
              HomePage(),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.backgroundColor,
        onPressed: () {},
        child: const Icon(
          Icons.search,
          color: AppColors.white,
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
