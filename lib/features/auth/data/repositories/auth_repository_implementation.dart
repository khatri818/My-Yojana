import '../../../../core/model/form/user_session.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_data_source.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImplementation(this._authDataSource);


  @override
  AppSuccessResponse loginUser(
          {required String userIdToken, required String userUID}) =>
      _authDataSource.loginUser(userIdToken: userIdToken, userUID: userUID);

  @override
  AppSuccessResponse logout() => _authDataSource.logout();

  @override
  AppSuccessResponse registerUser(
          {required UserSignUpForm userSignUpFormData}) =>
      _authDataSource.registerUser(userSignUpFormData: userSignUpFormData);

  @override
  AppTypeResponse<UserSession> checkUser() => _authDataSource.checkUser();

}
