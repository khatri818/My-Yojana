import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  RegisterUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  AppSuccessResponse call({required UserSignUpForm userSignUpFormData}) =>
      _authRepository.registerUser(userSignUpFormData: userSignUpFormData);
}
