import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../domain/entities/scheme.dart';
import 'scheme_card_style.dart';
import '../pages/scheme_detail_page.dart';
import '../../../auth/presentation/manager/auth_manger.dart';

class SchemeItem extends StatefulWidget {
  const SchemeItem({super.key, required this.scheme});
  final Scheme scheme;

  @override
  State<SchemeItem> createState() => _SchemeItemState();
}

class _SchemeItemState extends State<SchemeItem> {
  String firebaseId = '';
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadFirebaseId();
  }

  // Load the Firebase ID and User ID dynamically
  Future<void> _loadFirebaseId() async {
    final authManager = context.read<AuthManager>();
    final userIdFromManager = context.read<UserManager>().user?.id;
    final session = await authManager.checkUser();

    if (!mounted) return;

    setState(() {
      firebaseId = session?.token ?? '';
      userId = userIdFromManager ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;

    final String name = scheme.schemeName ?? 'Unknown Scheme';
    final String category = scheme.category ?? 'Uncategorized';
    final String description = scheme.description ?? 'No description available';
    final List<Color> gradientColors = SchemeCardStyle.getGradient(category);

    final double? averageRating = scheme.averagerating;
    final int? totalRating = scheme.totalrating;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94,
        height: 200,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchemeDetailPage(
                  schemeId: scheme.id!,
                  firebaseId: firebaseId,
                  userId: userId,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: SchemeCardStyle.buildBackgroundIcon(category: category),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SchemeCardStyle.buildIcon(
                                category: category,
                                size: 18,
                                withShadow: false,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Scheme Title
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Description
                        Expanded(
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14.5,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Ratings Section
                        if (averageRating != null || totalRating != null)
                          Row(
                            children: [
                              if (averageRating != null) ...[
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [Colors.amber, Colors.orangeAccent],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcIn,
                                  child: const Icon(Icons.star_rounded, size: 18),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              if (totalRating != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  "(${totalRating.toInt()} ratings)",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
