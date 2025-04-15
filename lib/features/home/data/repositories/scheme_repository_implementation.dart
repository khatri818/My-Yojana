import 'package:my_yojana/features/home/domain/entities/bookmark.dart';

import '../../../../core/utils/type_def.dart';
import '../../domain/entities/scheme.dart';
import '../../domain/repositories/scheme_repository.dart';
import '../data_source/scheme_data_source.dart';

class SchemeRepositoryImplementation extends SchemeRepository {
  final SchemeDataSource _schemeDataSource;

  SchemeRepositoryImplementation(this._schemeDataSource);

  @override
  AppTypeResponse<List<Scheme>> getScheme({
    required String query,
    required int page,
      required String category,
      required String gender,
      required String city,
      required double income_max,
      required bool differently_abled,
      required bool minority,
      required bool bpl_category}) => _schemeDataSource.getScheme(
      query: query,
      page: page,
      category: category,
      gender: gender,
      city: city,
      income_max: income_max,
      differently_abled: differently_abled,
      minority: minority,
      bpl_category: bpl_category);

  @override
  AppTypeResponse<List<Scheme>> getTopRatedScheme() => _schemeDataSource.getTopRatedScheme();

  @override
  AppTypeResponse<Scheme> getSchemeId({required int schemeId, required String firebaseId}) => _schemeDataSource.getSchemeId(
      schemeId: schemeId, firebaseId: firebaseId);

  @override
  AppSuccessResponse rateScheme({required int schemeId,required int userId,
    required double rating}) => _schemeDataSource.rateScheme(schemeId: schemeId, userId: userId, rating : rating);

  @override
  AppSuccessResponse createBookmark({required String firebaseId, required int schemeId}) => _schemeDataSource.createBookmark(firebaseId: firebaseId, schemeId: schemeId);

  @override
  AppSuccessResponse deleteBookmark({required String firebaseId, required int bookmarkId}) => _schemeDataSource.deleteBookmark(firebaseId: firebaseId, bookmarkId: bookmarkId);

  @override
  AppTypeResponse<List<Bookmark>> getBookmark({required int userId, required int page}) => _schemeDataSource.getBookmark(userId: userId, page: page);

}
