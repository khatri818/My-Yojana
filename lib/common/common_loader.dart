import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppCircularProgress extends StatelessWidget {
  final Color? backgroundColor;
  const AppCircularProgress({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: backgroundColor ?? AppColors.primary,
      ),
    );
  }
}
