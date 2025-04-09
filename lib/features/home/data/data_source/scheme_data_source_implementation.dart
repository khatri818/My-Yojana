import 'package:dartz/dartz.dart';
import 'package:my_yojana/features/home/data/data_source/scheme_data_source.dart';
import '../../../../api/api.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/services/storage_service.dart';
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
}