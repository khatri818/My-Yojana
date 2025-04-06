import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../repositories/user_repository.dart';

class AddUserUseCase {
  AddUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  AppSuccessResponse call({required UserSignUpForm userSignUpForm}) =>
      _userRepository.addNewUser(userSignUpForm: userSignUpForm);
}
