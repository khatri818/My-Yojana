import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class DeleteBookmarkUseCase {
  final SchemeRepository _schemeRepository;

  DeleteBookmarkUseCase(this._schemeRepository);

  AppSuccessResponse call({required String firebaseId, required int bookmarkId}) => _schemeRepository.deleteBookmark(firebaseId: firebaseId, bookmarkId: bookmarkId);
}
