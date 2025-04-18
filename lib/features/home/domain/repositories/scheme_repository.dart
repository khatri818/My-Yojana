import 'package:my_yojana/features/home/domain/entities/bookmark.dart';

import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';

abstract class SchemeRepository {
  AppTypeResponse<List<Scheme>> getScheme({
    required String query,
    required int page,
    required String category,
    required String gender,
    required String city,
    required double income_max,
    required bool? differently_abled,
    required bool? minority,
    required bool? bpl_category});

  AppTypeResponse<List<Scheme>> getTopRatedScheme();
  AppTypeResponse<Scheme> getSchemeId({required int schemeId, required String firebaseId});

  AppSuccessResponse rateScheme({required int schemeId, required int userId,
    required double rating});

  AppSuccessResponse createBookmark({required String firebaseId, required int schemeId});
  AppSuccessResponse deleteBookmark({required String firebaseId, required int bookmarkId});

  AppTypeResponse<List<Bookmark>> getBookmark({required int userId, required int page});
}
