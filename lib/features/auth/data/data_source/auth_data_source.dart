import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/model/failure.dart';
import '../../../../core/model/form/user_session.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/type_def.dart';
import '../../domain/entities/check_user_response.dart';

abstract class AuthDataSource {
  Future<Either<Failure, CheckUserResponse>> checkUserMobile(
      {required int mobile});
  AppTypeResponse<UserSession> checkUser();
  AppSuccessResponse loginUser(
      {required String userIdToken, required String userUID});
  AppSuccessResponse logout();
  AppSuccessResponse registerUser({required UserSignUpForm userSignUpFormData});
}
