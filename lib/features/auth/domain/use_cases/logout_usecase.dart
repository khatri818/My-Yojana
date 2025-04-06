import '../../../../core/utils/type_def.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;
  AppSuccessResponse call() => _authRepository.logout();
}
