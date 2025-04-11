import 'package:dartz/dartz.dart';
import '../../../../core/utils/http_utils.dart';
import '../../../../core/utils/type_def.dart';
import 'user_data_source.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../../../api/api.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/app_success.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/utils/log_utility.dart';

class UserDataSourceImplementation implements UserDataSource {
  final AppHttp _http;

  UserDataSourceImplementation(this._http);

  @override
  AppTypeResponse<User> getUser({required String firebaseId}) async {
    try {
      final response = await _http.get(path: Api.getUser(firebaseId)); // Changed from post to get

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
              message: data['error'] ?? 'Something went wrong!'));
        }

        return Right(UserModel.fromJson(data)); // No need for data['data']
      });
    } catch (e) {
      LogUtility.error('Get User Error : $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppTypeResponse<void> deleteUser({required String firebaseId}) async {
    try {
      final response = await _http.delete(path: Api.deleteUser(firebaseId));

      return response.fold(
            (l) => Left(ErrorMessage(message: l.message)),
            (result) async {
          final statusCode = result.statusCode;
          final data = result.data;

          if (statusCode == null || statusCode >= 400) {
            // Safely check if data is a Map and contains 'error'
            final errorMsg = (data is Map && data.containsKey('error'))
                ? data['error']
                : 'Failed to delete user.';
            return Left(ErrorMessage(message: errorMsg));
          }

          return const Right(null); // success, no data to return
        },
      );
    } catch (e, stackTrace) {
      LogUtility.error('Delete User Error : $e\n$stackTrace');
      return Left(ErrorMessage(message: 'Unexpected error occurred.'));
    }
  }

  @override
  AppSuccessResponse addNewUser({required UserSignUpForm userSignUpForm}) async {
    try {
      final body = userSignUpForm.toMap();
      LogUtility.info('User new body : $body');
      final response = await _http.post(path: Api.register, data: body); // Fixed endpoint

      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
              message: data['error'] ?? 'Something went wrong!'));
        }

        return Right(SuccessMessage(
            message: data['message'] ?? 'User Added Successfully.'));
      });
    } catch (e) {
      LogUtility.error('Adding User Error : $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppSuccessResponse updateUser({
    required String firebaseId,
    required UserSignUpForm userSignUpForm,
  }) async {
    try {
      final body = userSignUpForm.toMap();
      LogUtility.info('Update User [$firebaseId] with body: $body');

      final response = await _http.put(
        path: Api.updateUser(firebaseId),
        data: body,
      );

      return response.fold(
            (l) => Left(ErrorMessage(message: l.message)),
            (result) async {
          final statusCode = result.statusCode;
          final data = result.data;

          if (statusCode == null || statusCode >= 400) {
            return Left(ErrorMessage(
                message: data['error'] ?? 'Failed to update user.'));
          }

          return Right(SuccessMessage(
              message: data['message'] ?? 'User updated successfully.'));
        },
      );
    } catch (e, stackTrace) {
      LogUtility.error('Update User Error : $e\n$stackTrace');
      return const Left(ErrorMessage(message: 'Unexpected error occurred.'));
    }
  }

}
