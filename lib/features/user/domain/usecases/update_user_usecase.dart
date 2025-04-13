import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  UpdateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  AppSuccessResponse call({required String firebaseId,required UserSignUpForm userSignUpForm}) =>
      _userRepository.updateUser(firebaseId : firebaseId,userSignUpForm: userSignUpForm);
}
