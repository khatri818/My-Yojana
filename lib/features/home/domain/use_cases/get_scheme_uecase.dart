import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class GetSchemeUseCase {
  final SchemeRepository _schemeRepository;

  GetSchemeUseCase(this._schemeRepository);

  AppTypeResponse<List<Scheme>> call({
    required String query,
    required int page,
    required String category,
    required String gender,
    required String city,
    required double income_max,
    required bool? differently_abled,
    required bool? minority,
    required bool? bpl_category}) => _schemeRepository.getScheme(
      query: query,
      page: page,
      category: category,
      gender: gender,
      city: city,
      income_max: income_max,
      differently_abled: differently_abled,
      minority: minority,
      bpl_category: bpl_category);

}
