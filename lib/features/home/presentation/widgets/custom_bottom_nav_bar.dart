import 'dart:ui';
import 'package:flutter/material.dart';
import 'bottom_nav_item.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.1;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1000.0, sigmaY: 1000.0),
        child: Container(
          height: appBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2575FC).withOpacity(0.12), // Lighter blue
                const Color(0xFF6A11CB).withOpacity(0.12), // Lighter violet
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: const Border(
              top: BorderSide(color: Colors.transparent, width: 0),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: BottomNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: BottomNavItem(
                  index: 1,
                  icon: Icons.bookmarks_outlined,
                  label: 'Bookmark',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
