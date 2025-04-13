import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class CreateBookmarkUseCase {
  final SchemeRepository _schemeRepository;

  CreateBookmarkUseCase(this._schemeRepository);

  AppSuccessResponse call({required String firebaseId, required int schemeId}) => _schemeRepository.createBookmark(firebaseId: firebaseId, schemeId: schemeId);
}
