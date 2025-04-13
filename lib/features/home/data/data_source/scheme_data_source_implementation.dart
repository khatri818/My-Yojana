import 'package:dartz/dartz.dart';
import 'package:my_yojana/features/home/data/data_source/scheme_data_source.dart';
import '../../../../api/api.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/app_success.dart';
import '../../../../core/utils/http_utils.dart';
import '../../../../core/utils/log_utility.dart';
import '../../../../core/utils/type_def.dart';
import '../../domain/entities/scheme.dart';
import '../models/scheme_model.dart';

class SchemeDataSourceImplementation extends SchemeDataSource {
  SchemeDataSourceImplementation(this._http);

  final AppHttp _http;

  @override
  AppTypeResponse<List<Scheme>> getScheme({
    required int page,
    required String category,
    required String gender,
    required String city,
    required double income_max,
    required bool differently_abled,
    required bool minority,
    required bool bpl_category
  }) async {
    try {
      final response = await _http.get(
          path: Api.getScheme(
              page: page,
              category: category,
              gender: gender,
              city: city,
              income_max: income_max,
              differently_abled: differently_abled,
              minority: minority,
              bpl_category: bpl_category
          ),
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
              message: data['error'] ?? 'Something went wrong!'));
        }

        final List<Scheme> schemes = (data['schemes'] as List)
            .map((schemeJson) => SchemeModel.fromJson(schemeJson))
            .toList();

        return Right(schemes);
      });
    } catch (e) {
      LogUtility.error('Get Scheme Error : $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppTypeResponse<List<Scheme>> getTopRatedScheme() async {
    try {
      final response = await _http.get(
        path: Api.getTopRatedScheme(),
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
              message: data['error'] ?? 'Something went wrong!'));
        }

        final rawList = data['top_rated_schemes'];
        if (rawList == null || rawList is! List) {
          return Left(ErrorMessage(message: 'Invalid or missing top-rated schemes data.'));
        }

        final List<Scheme> schemes = rawList
            .map((schemeJson) => SchemeModel.fromJson(schemeJson))
            .toList()
            .cast<Scheme>();

        return Right(schemes);
      });
    } catch (e) {
      LogUtility.error('Get Scheme Error : $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }



  @override
  AppTypeResponse<Scheme> getSchemeId({required int schemeId}) async {
    try {
      final response = await _http.get(
        path: Api.getSchemeId(schemeId),
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
            message: data['error'] ?? 'Something went wrong!',
          ));
        }

        final Scheme scheme = SchemeModel.fromJson(data); // ✅ FIX HERE
        return Right(scheme);
      });
    } catch (e) {
      LogUtility.error('Get Scheme Error : $e');
      return Left(ErrorMessage(message: e.toString()));
    }
  }

  @override
  AppSuccessResponse rateScheme({
    required int schemeId,
    required int userId,
    required double rating,
  }) async {
    try {
      final body = {
        "user_id": userId,
        "rating": rating,
      };
      LogUtility.info('Rating body: $body');

      final response = await _http.post(
        path: Api.rateScheme(schemeId),
        data: body,
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
            message: data['message'] ?? data['error'] ?? 'Rating failed.',
          ));
        }

        return Right(SuccessMessage(
          message: data['message'] ?? 'Rating submitted successfully.',
        ));
      });
    } catch (e) {
      LogUtility.error('Rate Scheme Error: $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppSuccessResponse createBookmark({
    required String firebaseId,
    required int schemeId,
  }) async {
    try {
      final body = {
        "firebase_id": firebaseId,
        'scheme_id': schemeId,
      };
      LogUtility.info('Bookmark body: $body');

      final response = await _http.post(
        path: Api.createBookmark(),
        data: body,
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
            message: data['message'] ?? data['error'] ?? 'Bookmark creation failed.',
          ));
        }

        return Right(SuccessMessage(
          message: data['message'] ?? 'Bookmark created successfully.',
        ));
      });
    } catch (e) {
      LogUtility.error('Create Bookmark Error: $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppSuccessResponse deleteBookmark({
    required String firebaseId,
    required int bookmarkId,
  }) async {
    try {
      final body = {
        "firebase_id": firebaseId,
      };
      LogUtility.info('Bookmark body: $body');

      final response = await _http.delete(
        path: Api.deleteBookmark(bookmarkId),
        data: body,
      );

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
            message: data['message'] ?? data['error'] ?? 'Bookmark creation failed.',
          ));
        }

        return Right(SuccessMessage(
          message: data['message'] ?? 'Bookmark created successfully.',
        ));
      });
    } catch (e) {
      LogUtility.error('Create Bookmark Error: $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

}