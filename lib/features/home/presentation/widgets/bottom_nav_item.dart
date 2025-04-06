import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../manager/bottom_nav_manager.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(
      {super.key,
        required this.index,
        required this.icon,
        required this.label});

  final int index;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, provider, child) {
        Color color = index == provider.selectedIndex
            ? AppColors.backgroundColor
            : AppColors.grey;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(icon, size: 28),
                color: color,
                onPressed: () => provider.selectTab(index),
              ),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
