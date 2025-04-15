import '../../domain/entities/bookmark.dart';

class BookmarkModel {
  final int? bookmarkId;
  final int? schemeId;
  final String? schemeName;
  final String? category;
  final String? description;
  final String? bookmarkedAt;
  final String? notes;
  final int? totalRatings;
  final double? averageRating;

  const BookmarkModel({
    this.bookmarkId,
    this.schemeId,
    this.schemeName,
    this.category,
    this.description,
    this.bookmarkedAt,
    this.notes,
    this.totalRatings,
    this.averageRating,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> map) {
    return BookmarkModel(
      bookmarkId: map['bookmark_id'] as int?,
      schemeId: map['scheme_id'] as int?,
      schemeName: map['scheme_name']?.toString(),
      category: map['category']?.toString(),
      description: map['description']?.toString(),
      bookmarkedAt: map['bookmarked_at']?.toString(),
      notes: map['notes']?.toString(),
      totalRatings: map['total_ratings'] as int?,
      averageRating: (map['average_rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookmark_id': bookmarkId,
      'scheme_id': schemeId,
      'scheme_name': schemeName,
      'category': category,
      'description': description,
      'bookmarked_at': bookmarkedAt,
      'notes': notes,
      'total_ratings': totalRatings,
      'average_rating': averageRating,
    };
  }

  /// ✅ Convert model to domain entity
  Bookmark toEntity() {
    return Bookmark(
      bookmarkId: bookmarkId,
      schemeId: schemeId,
      schemeName: schemeName,
      category: category,
      description: description,
      bookmarkedAt: bookmarkedAt,
      notes: notes,
      totalRatings: totalRatings,
      averageRating: averageRating,
    );
  }
}
