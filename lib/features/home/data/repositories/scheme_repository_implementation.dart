import '../../../../core/utils/type_def.dart';
import '../../domain/entities/scheme.dart';
import '../../domain/repositories/scheme_repository.dart';
import '../data_source/scheme_data_source.dart';

class SchemeRepositoryImplementation extends SchemeRepository {
  final SchemeDataSource _schemeDataSource;

  SchemeRepositoryImplementation(this._schemeDataSource);

  @override
  AppTypeResponse<List<Scheme>> getScheme({required int page,
      required String category,
      required String gender,
      required String city,
      required double income_max,
      required bool differently_abled,
      required bool minority,
      required bool bpl_category}) => _schemeDataSource.getScheme(
      page: page,
      category: category,
      gender: gender,
      city: city,
      income_max: income_max,
      differently_abled: differently_abled,
      minority: minority,
      bpl_category: bpl_category);

}
