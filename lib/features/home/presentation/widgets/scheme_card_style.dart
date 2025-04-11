import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // or use Material Icons

class SchemeCardStyle {
  static Map<String, List<Color>> categoryGradients = {
    'Education': [Colors.deepPurpleAccent, Colors.purple],
    'Scholarship': [Colors.indigoAccent, Colors.blueAccent],
    'Hospital': [Colors.teal, Colors.green],
    'Agriculture': [Colors.lightGreen, Colors.green],
    'Insurance': [Colors.orange, Colors.deepOrange],
    'Housing': [Colors.brown, Colors.orangeAccent],
    'Fund support': [Colors.pinkAccent, Colors.redAccent],
  };

  static Map<String, IconData> categoryIcons = {
    'Education': Icons.school,
    'Scholarship': Icons.emoji_events_outlined,
    'Hospital': Icons.local_hospital,
    'Agriculture': Icons.agriculture,
    'Insurance': Icons.shield_outlined,
    'Housing': Icons.house,
    'Fund support': Icons.volunteer_activism,
  };

  static List<Color> getGradient(String category) =>
      categoryGradients[category] ?? [Colors.grey.shade400, Colors.grey.shade600];

  static IconData getIcon(String category) =>
      categoryIcons[category] ?? Icons.category;
}
