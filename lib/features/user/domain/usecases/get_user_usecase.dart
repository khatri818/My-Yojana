import '../../../../core/utils/type_def.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  AppTypeResponse<User> call({required String firebaseId}) {
    return _userRepository.getUser(firebaseId: firebaseId);
  }
}
