import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/scheme.dart';
import 'scheme_card_style.dart'; // Make sure this file exists with style mappings

class SchemeItem extends StatelessWidget {
  const SchemeItem({
    super.key,
    required this.scheme,
  });

  final Scheme scheme;

  @override
  Widget build(BuildContext context) {
    final String name = scheme.schemeName ?? 'Unknown Scheme';
    final String category = scheme.category ?? 'Uncategorized';
    final String description = scheme.description ?? 'No description available';
    final String? launchDateStr = scheme.launchDate;

    final List<Color> gradientColors = SchemeCardStyle.getGradient(category);
    final IconData backgroundIcon = SchemeCardStyle.getIcon(category);

    DateTime? parsedDate;
    if (launchDateStr != null && launchDateStr.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(launchDateStr);
      } catch (_) {}
    }

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95, // Wider card
        height: 180,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Faint background icon
              Positioned(
                right: 10,
                bottom: 10,
                child: Icon(
                  backgroundIcon,
                  size: 100,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Category: $category',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (parsedDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat.yMMMd().format(parsedDate),
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
