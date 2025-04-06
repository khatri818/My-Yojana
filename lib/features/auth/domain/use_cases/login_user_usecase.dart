import '../../../../core/utils/type_def.dart';
import '../repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository _authRepository;

  LoginUserUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;
  AppSuccessResponse call(
          {required String userIdToken, required String userUID}) =>
      _authRepository.loginUser(userIdToken: userIdToken, userUID: userUID);
}
