import 'package:flutter/material.dart';

class SchemeCardStyle {
  // Gradient color mapping for each category
  static Map<String, List<Color>> categoryGradients = {
    'Health': [Colors.teal.shade400, Colors.green.shade600],
    'Insurance': [Colors.orange.shade400, Colors.deepOrange.shade600],
    'Employment': [Colors.blue.shade400, Colors.indigo.shade600],
    'Agriculture': [Colors.lightGreen.shade400, Colors.green.shade800],
    'Housing': [Colors.brown.shade400, Colors.orangeAccent.shade700],
    'Financial Assistance': [Colors.pink.shade300, Colors.redAccent.shade700],
    'Safety': [Colors.deepOrange.shade400, Colors.red.shade700],
    'Subsidy': [Colors.amber.shade400, Colors.yellow.shade700],
    'Education': [Colors.deepPurpleAccent.shade100, Colors.purple.shade700],
    'Pension': [Colors.grey.shade600, Colors.blueGrey.shade800],
    'Business': [Colors.cyan.shade400, Colors.blueAccent.shade700],
    'Loan': [Colors.indigoAccent.shade200, Colors.cyanAccent.shade700],
  };

  // Icon mapping for each category
  static Map<String, IconData> categoryIcons = {
    'Health': Icons.favorite,
    'Insurance': Icons.verified_user,
    'Employment': Icons.badge,
    'Agriculture': Icons.eco,
    'Housing': Icons.home_work,
    'Financial Assistance': Icons.volunteer_activism,
    'Safety': Icons.health_and_safety,
    'Subsidy': Icons.monetization_on,
    'Education': Icons.menu_book,
    'Pension': Icons.elderly,
    'Business': Icons.trending_up,
    'Loan': Icons.account_balance_wallet,
  };

  // Fallback gradient
  static List<Color> getGradient(String category) =>
      categoryGradients[category] ?? [Colors.grey.shade400, Colors.grey.shade600];

  // Fallback icon
  static IconData getIcon(String category) =>
      categoryIcons[category] ?? Icons.category;

  /// Build a foreground icon (for badge or header), optionally with shadow for contrast
  static Widget buildIcon({
    required String category,
    double size = 26,
    bool withShadow = true,
  }) {
    return Icon(
      getIcon(category),
      size: size,
      color: Colors.white,
      shadows: withShadow
          ? [
        Shadow(
          blurRadius: 4,
          offset: Offset(1.5, 1.5),
          color: Colors.black.withOpacity(0.3),
        ),
      ]
          : [],
    );
  }

  /// Build a stylized circular icon (ideal for category tags or headers)
  static Widget buildCircularIcon({
    required String category,
    double radius = 22,
    double iconSize = 20,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withOpacity(0.2),
      child: Icon(
        getIcon(category),
        size: iconSize,
        color: Colors.white,
      ),
    );
  }

  /// Build a large faint background icon (for decorative background use)
  static Widget buildBackgroundIcon({
    required String category,
    double size = 110,
    double opacity = 0.07,
  }) {
    return Icon(
      getIcon(category),
      size: size,
      color: Colors.white.withOpacity(opacity),
    );
  }
}

