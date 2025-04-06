import '../../../../core/model/form/user_session.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';

abstract class AuthRepository {
  AppTypeResponse<UserSession> checkUser();
  AppSuccessResponse logout();
  AppSuccessResponse loginUser(
      {required String userIdToken, required String userUID});
  AppSuccessResponse registerUser({required UserSignUpForm userSignUpFormData});
}
