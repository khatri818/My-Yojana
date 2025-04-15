import 'package:my_yojana/features/home/domain/entities/bookmark.dart';

import '../../../../core/utils/type_def.dart';
import '../entities/scheme.dart';
import '../repositories/scheme_repository.dart';

class GetBookmarkUseCase {
  final SchemeRepository _schemeRepository;

  GetBookmarkUseCase(this._schemeRepository);

  AppTypeResponse<List<Bookmark>> call({required int userId,
    required int page,
    }) => _schemeRepository.getBookmark(userId: userId,
      page: page,);

}
