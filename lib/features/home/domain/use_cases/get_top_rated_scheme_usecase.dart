import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class GetTopRatedSchemeUseCase {
  final SchemeRepository _schemeRepository;

  GetTopRatedSchemeUseCase(this._schemeRepository);

  AppTypeResponse<List<Scheme>> call() => _schemeRepository.getTopRatedScheme();
}
