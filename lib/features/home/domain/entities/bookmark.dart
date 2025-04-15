import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final int? bookmarkId;
  final int? schemeId;
  final String? schemeName;
  final String? category;
  final String? description;
  final String? bookmarkedAt;
  final String? notes;
  final int? totalRatings;
  final double? averageRating;

  const Bookmark({
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


  @override
  List<Object?> get props => [
    bookmarkId,
    schemeId,
    schemeName,
    category,
    description,
    bookmarkedAt,
    notes,
    totalRatings,
    averageRating,
  ];
}
