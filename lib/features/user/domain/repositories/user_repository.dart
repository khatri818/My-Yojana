import 'package:my_yojana/core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../entities/user.dart';

abstract class UserRepository {
  /// Fetches user details based on Firebase ID
  AppTypeResponse<User> getUser({required String firebaseId});

  /// Adds a new user with the provided sign-up form data
  AppSuccessResponse addNewUser({required UserSignUpForm userSignUpForm});
}
