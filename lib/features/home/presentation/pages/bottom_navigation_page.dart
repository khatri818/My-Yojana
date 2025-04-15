import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_yojana/features/home/presentation/pages/search_screen.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../constant/image_resource.dart';
import '../../../../core/enum/status.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../manager/bottom_nav_manager.dart';
import '../manager/scheme_manger.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'bookmark_screen.dart';
import 'home_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool _hasFetched = false; // ✅ Prevent repeated API calls

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchUserAndSchemes());
  }

  Future<void> _fetchUserAndSchemes() async {
    if (_hasFetched) return; // ✅ Avoid fetching again
    _hasFetched = true;

    try {
      final authManager = context.read<AuthManager>();
      final userSession = await authManager.checkUser();

      if (userSession != null && mounted) {
        final userManager = context.read<UserManager>();
        final schemeManager = context.read<SchemeManager>();

        await userManager.getUser(userSession.token);

        final schemeList = schemeManager.scheme;
        final schemeStatus = schemeManager.schemeLoadingStatus;

        if (schemeStatus != Status.loading &&
            (schemeList == null || schemeList.isEmpty)) {
          await schemeManager.getScheme(showLoading: true);
        }
      } else {
        debugPrint('User session is null');
      }
    } catch (e, stack) {
      debugPrint('Error fetching user: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: const Border(
                  bottom: BorderSide(color: Colors.white24, width: 0.3),
                ),
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Image.asset(ImageResource.bannerLogo, height: 45),
                centerTitle: true,
              ),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: const [
              HomePage(),
              BookmarkPage(),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x332575FC),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchPage(isMatchScheme: false),
                ),
              );
            },
            child: const Center(
              child: Icon(Icons.search, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
