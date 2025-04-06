import '../../../../core/model/form/user_session.dart';
import '../../../../core/utils/type_def.dart';
import '../repositories/auth_repository.dart';

class CheckUserUseCase {
  final AuthRepository _authRepository;

  CheckUserUseCase(this._authRepository);

  AppTypeResponse<UserSession> call() => _authRepository.checkUser();
}
