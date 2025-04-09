import '../../../../core/utils/type_def.dart';
import '../../domain/entities/scheme.dart';

abstract class SchemeDataSource {
  AppTypeResponse<List<Scheme>> getScheme({required int page,
    required String category,
    required String gender,
    required String city,
    required double income_max,
    required bool differently_abled,
    required bool minority,
    required bool bpl_category});
}
