import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../domain/entities/bookmark.dart'; // ✅ Use entity instead of model
import '../manager/scheme_manger.dart';
import '../pages/scheme_detail_page.dart';
import 'scheme_card_style.dart';

class BookmarkItem extends StatefulWidget {
  final Bookmark bookmark;

  const BookmarkItem({super.key, required this.bookmark});

  @override
  State<BookmarkItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends State<BookmarkItem> {
  String firebaseId = '';

  @override
  void initState() {
    super.initState();
    _loadFirebaseId();
  }

  // Load Firebase ID from AuthManager
  Future<void> _loadFirebaseId() async {
    final authManager = context.read<AuthManager>();
    final session = await authManager.checkUser();
    if (!mounted) return;
    setState(() => firebaseId = session?.token ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final bookmark = widget.bookmark;
    final String name = bookmark.schemeName ?? 'Unknown Scheme';
    final String category = bookmark.category ?? 'Uncategorized';
    final String description = bookmark.description ?? 'No description available';
    final List<Color> gradientColors = SchemeCardStyle.getGradient(category);

    final double? averageRating = bookmark.averageRating;
    final int? totalRating = bookmark.totalRatings;

    // Use Consumer to listen to changes in SchemeManager
    return Consumer<SchemeManager>(
      builder: (context, schemeManager, child) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.94,
            height: 200,
            child: InkWell(
              onTap: () {
                final userId = context.read<UserManager>().user?.id;
                if (bookmark.schemeId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchemeDetailPage(
                        schemeId: bookmark.schemeId!,
                        firebaseId: firebaseId,
                        userId: userId!,
                      ),
                    ),
                  );
                }
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
                                      withShadow: false
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
      },
    );
  }
}
