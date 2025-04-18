import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class GetSchemeIdUseCase {
  final SchemeRepository _schemeRepository;

  GetSchemeIdUseCase(this._schemeRepository);

  AppTypeResponse<Scheme> call({required int schemeId, required String firebaseId}) => _schemeRepository.getSchemeId(schemeId : schemeId, firebaseId: firebaseId);

}
