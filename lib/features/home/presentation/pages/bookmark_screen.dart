import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../domain/entities/bookmark.dart';
import '../manager/scheme_manger.dart';
import '../widgets/bookmark_item.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  BookmarkPageState createState() => BookmarkPageState();
}

class BookmarkPageState extends State<BookmarkPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshBookmarks();
      refreshSchemes(); // ✅ Only once on mount
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Refresh bookmarks list
  Future<void> refreshBookmarks() async {
    final userId = context.read<UserManager>().user?.id;
    if (userId != null) {
      await context.read<SchemeManager>().getBookmarks(userId: userId, page: 1);
    }
  }

  // Refresh scheme data only if not already loaded or loading
  Future<void> refreshSchemes() async {
    final schemeManager = context.read<SchemeManager>();
    final userId = context.read<UserManager>().user?.id;

    if (userId != null &&
        (schemeManager.scheme == null || schemeManager.scheme!.isEmpty) &&
        schemeManager.schemeLoadingStatus != Status.loading) {
      schemeManager.resetState();
      schemeManager.setFilter('', '', '', 0.0, false, false, false);
      await schemeManager.getScheme(showLoading: true);
    }
  }

  // Handle scroll for pagination
  void _onScroll() {
    final schemeManager = context.read<SchemeManager>();
    final userId = context.read<UserManager>().user?.id;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        schemeManager.bookmarkFetchStatus != Status.loading &&
        schemeManager.hasMoreBookmarkSchemes &&
        userId != null) {
      schemeManager.getBookmarks(userId: userId, page: schemeManager.pageN + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchemeManager>(
      builder: (context, schemeManager, _) {
        final bookmarks = schemeManager.bookmarks;
        final status = schemeManager.bookmarkFetchStatus;

        // Loading state
        if (status == Status.loading && (bookmarks == null || bookmarks.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        // Failure state with retry option
        if (status == Status.failure && (bookmarks == null || bookmarks.isEmpty)) {
          return _buildMessageWithRetry(
            icon: Icons.error_outline,
            message: "Failed to load bookmarks.",
            onRetry: refreshBookmarks,
          );
        }

        // No bookmarks available state
        if (bookmarks == null || bookmarks.isEmpty) {
          return _buildMessageWithRetry(
            icon: Icons.bookmark_border,
            message: "No bookmarks available.",
          );
        }

        // Display bookmarks with pagination
        return RefreshIndicator(
          onRefresh: refreshBookmarks,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 80),
            itemCount: bookmarks.length + 1,
            itemBuilder: (context, index) {
              if (index == bookmarks.length) {
                return schemeManager.bookmarkFetchStatus == Status.loading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const SizedBox.shrink();
              }

              final Bookmark bookmark = bookmarks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BookmarkItem(bookmark: bookmark),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Widget for showing messages with retry option
  Widget _buildMessageWithRetry({
    required IconData icon,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade500),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.indigo.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
