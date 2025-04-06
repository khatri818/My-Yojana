import 'package:dartz/dartz.dart';
import '../../../../api/api.dart';
import '../../../../core/constant/app_text.dart';
import '../../../../core/constant/storage_key.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/app_success.dart';
import '../../../../core/model/failure.dart';
import '../../../../core/model/form/user_session.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/http_utils.dart';
import '../../../../core/utils/log_utility.dart';
import '../../../../core/utils/type_def.dart';
import 'auth_data_source.dart';
import '../../domain/entities/check_user_response.dart';

class AuthDataSoruceImplementation extends AuthDataSource {
  AuthDataSoruceImplementation(this._http, this._localStorage);

  final AppHttp _http;
  final LocalStorage _localStorage;

  @override
  Future<Either<Failure, CheckUserResponse>> checkUserMobile(
      {required int mobile}) {
    throw UnimplementedError();
  }


  @override
  AppSuccessResponse loginUser(
      {required String userIdToken, required String userUID}) async {
    try {
      final token = userUID;

      LogUtility.info('Updated Token ::: $token');
      LogUtility.info('Requesting user data with token: $token');

      final userResponse = await _http.get(path: Api.getUser(token));

      return userResponse.fold(
            (left) async {
          LogUtility.error('Error in response: ${left.message}');

          // Check if error indicates a new user
          if (left.message.contains("User with firebase_id") && left.message.contains("not found")) {
            LogUtility.info('New user detected. Proceeding with default setup.');

            await _localStorage.writeBool(
              SecureStorageItem<bool>(key: StorageKey.isNewUser, value: true),
            );
            await _localStorage.write(
              SecureStorageItem(key: StorageKey.token, value: token),
            );

            return const Right(SuccessMessage(
              message: 'New user detected. Proceeding with onboarding.',
            ));
          }

          return Left(ErrorMessage(message: left.message));
        },
            (result) async {
          final statusCode = result.statusCode;
          final data = result.data;

          LogUtility.info('Response Status Code: $statusCode');
          LogUtility.info('User Response: $data');

          if (statusCode == null || statusCode >= 400) {
            final errorMessage = data['message'] ?? data['error'] ?? 'Something went wrong!';
            LogUtility.error('Error message: $errorMessage');
            return Left(ErrorMessage(message: errorMessage));
          }

          await _localStorage.writeBool(
            SecureStorageItem<bool>(key: StorageKey.isNewUser, value: false),
          );
          await _localStorage.writeMultiple([
            SecureStorageItem(key: StorageKey.token, value: token),
            SecureStorageItem(key: StorageKey.mobile, value: data['mobileNumber'].toString()),
          ]);

          LogUtility.info('Login successful for user: ${data['name']}');

          return Right(SuccessMessage(
            message: 'Login successful. Welcome, ${data['name']}!',
          ));
        },
      );
    } catch (e, stacktrace) {
      LogUtility.error('Login User Error: $e');
      LogUtility.error('Stack Trace: $stacktrace');
      return Left(ErrorMessage(message: e.toString()));
    }
  }



  // @override
  // AppSuccessResponse loginUser({required String userIdToken, required String userUID}) async {
  //   try {
  //     final token = userUID;
  //
  //     LogUtility.info('Updated Token ::: $token');
  //
  //     // Log the request details (Even though no actual request is made now)
  //     LogUtility.info('Processing login for user with token: $token');
  //
  //     // Simulate a response structure for local storage purposes (you can mock it or handle it however needed)
  //     final data = {
  //       'name': 'Mustafa Khatri',
  //       'mobileNumber': '9022152154',
  //       'countryCode': '+91',
  //     };
  //
  //     final statusCode = 200; // Assuming success status code for the mock response
  //
  //     // Log status code and response data (simulated)
  //     LogUtility.info('Response Status Code: $statusCode');
  //     LogUtility.info('User Response: $data');
  //
  //     if (statusCode == null || statusCode >= 400) {
  //       final errorMessage = 'Something went wrong!'; // Simulate an error message if status code is invalid
  //       LogUtility.error('Error message: $errorMessage');
  //       return Left(ErrorMessage(message: errorMessage));
  //     }
  //
  //     const isNewUser = false;
  //
  //     // Log the user info before saving to local storage
  //     LogUtility.info('Saving token and user data to local storage');
  //
  //     // Simulate saving data to local storage
  //     await _localStorage.writeBool(
  //       SecureStorageItem<bool>(key: StorageKey.isNewUser, value: isNewUser),
  //     );
  //     await _localStorage.writeMultiple([
  //       SecureStorageItem(key: StorageKey.token, value: token),
  //       SecureStorageItem(key: StorageKey.mobile, value: data['mobileNumber'].toString()),
  //       SecureStorageItem(key: StorageKey.countryCode, value: data['countryCode'].toString()),
  //     ]);
  //
  //     // Log successful login
  //     LogUtility.info('Login successful for user: $token');
  //
  //     return const Right(SuccessMessage(
  //       message: 'Login successful. Welcome!',
  //     ));
  //   } catch (e, stacktrace) {
  //     LogUtility.error('Login User Error: $e');
  //     LogUtility.error('Stack Trace: $stacktrace');
  //     return Left(
  //       ErrorMessage(
  //         message: e.toString(),
  //       ),
  //     );
  //   }
  // }


  @override
  AppSuccessResponse registerUser(
      {required UserSignUpForm userSignUpFormData}) async {
    try {
      final body = userSignUpFormData.toMap();
      LogUtility.info('Signup body : $body');
      final response = await _http.post(path: Api.register, data: body);
      return response.fold((l) {
        return Left(ErrorMessage(message: l.message));
      }, (result) async {
        final statusCode = result.statusCode;
        final data = result.data;

        if (statusCode == null || statusCode >= 400) {
          return Left(ErrorMessage(
              message:
              data['message'] ?? data['error'] ?? 'Something went wrong!'));
        }
        await _localStorage.writeBool(
          SecureStorageItem(key: StorageKey.isNewUser, value: false),
        );

        return Right(SuccessMessage(
            message: data['message'] ?? 'User Registered Successfully.'));
      });
    } catch (e) {
      LogUtility.error('Register User Error : $e');
      return Left(
        ErrorMessage(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  AppTypeResponse<UserSession> checkUser() async {
    try {
      final token = await _localStorage.read(StorageKey.token);
      if (token == null) {
        return const Left(ErrorMessage(message: 'User not logged in.'));
      }
      final isNewUser = await _localStorage.readBool(StorageKey.isNewUser);
      final mobileNumber = await _localStorage.read(StorageKey.mobile);


      return Right(UserSession(
          token: token,
          isNewUser: isNewUser ?? false));
    } catch (e) {
      return const Left(ErrorMessage(message: 'Something went wrong!'));
    }
  }

  @override
  AppSuccessResponse logout() async {
    try {
      await _localStorage.deleteAll();
      return const Right(SuccessMessage(message: AppText.successful));
    } catch (e) {
      return const Left(ErrorMessage(message: 'Something went wrong!'));
    }
  }
}