import '../../../../core/utils/type_def.dart';
import '../repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository _userRepository;

  DeleteUserUseCase(this._userRepository);

  AppTypeResponse<void> call({required String firebaseId}) {
    return _userRepository.deleteUser(firebaseId: firebaseId);
  }
}
