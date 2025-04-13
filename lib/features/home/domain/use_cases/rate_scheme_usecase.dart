import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class RateSchemeUseCase {
  final SchemeRepository _schemeRepository;

  RateSchemeUseCase(this._schemeRepository);

  AppSuccessResponse call({required int schemeId, required int userId,
    required double rating}) => _schemeRepository.rateScheme(schemeId: schemeId, userId: userId, rating : rating);
}
