import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_data_source.dart';

class UserRepositoryImplementation implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImplementation(this._userDataSource);

  @override
  AppTypeResponse<User> getUser({required String firebaseId}) async =>
      _userDataSource.getUser(firebaseId: firebaseId);

  @override
  AppTypeResponse<void> deleteUser({required String firebaseId}) async =>
      _userDataSource.deleteUser(firebaseId: firebaseId);

  @override
  AppSuccessResponse addNewUser({required UserSignUpForm userSignUpForm}) =>
      _userDataSource.addNewUser(userSignUpForm: userSignUpForm);
}
