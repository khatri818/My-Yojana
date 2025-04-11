import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../../domain/entities/user.dart';

abstract class UserDataSource {
   /// Fetches user details based on Firebase ID
   AppTypeResponse<User> getUser({required String firebaseId});
   AppTypeResponse<void> deleteUser({required String firebaseId});
   AppSuccessResponse updateUser({required String firebaseId,required UserSignUpForm userSignUpForm});
   AppSuccessResponse addNewUser({required UserSignUpForm userSignUpForm});
}
