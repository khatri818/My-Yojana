import 'package:flutter/material.dart';

import 'bottom_nav_item.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate the desired height based on screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.1; // Adjust this multiplier as needed

    return BottomAppBar(
      height: appBarHeight,
      padding: EdgeInsets.zero,
      color: Colors.white70,
      shape: const CircularNotchedRectangle(),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(index: 0, icon: Icons.home_outlined, label: 'Home'),
          BottomNavItem(index: 1, icon: Icons.bookmarks_outlined, label: 'Bookmark'),
          BottomNavItem(index: 2, icon: Icons.update_sharp, label: 'Schemes'),
          BottomNavItem(index: 3, icon: Icons.person_pin, label: 'My Profile'),
        ],
      ),
    );
  }
}
