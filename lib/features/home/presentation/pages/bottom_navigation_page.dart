import 'package:flutter/material.dart';
import 'package:my_yojana/features/home/presentation/pages/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../constant/image_resource.dart';
import '../manager/bottom_nav_manager.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white.withOpacity(0),
        title: Image.asset(ImageResource.bannerLogo,height: 45,),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: [
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
        onPressed: () {

        },
        child: const Icon(
          Icons.search,
          color: AppColors.white,
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
