import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constant/storage_key.dart';
import '../../../../core/model/form/user_session.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_alert.dart';
import '../../../../core/utils/log_utility.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/enum/status.dart';
import '../../domain/use_cases/check_user_uecase.dart';
import '../../domain/use_cases/login_user_usecase.dart';
import '../../domain/use_cases/logout_usecase.dart';
import '../../domain/use_cases/register_user_usecase.dart';

class AuthManager with ChangeNotifier {
  final LocalStorage _localStorage;
  final FirebaseAuthService _firebaseAuthService;

  // UseCases
  final CheckUserUseCase _checkUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUserUseCase _registerUserUseCase;

  bool isLoading = false;


  AuthManager(
      {
        required FirebaseAuthService firebaseAuthService,
        required CheckUserUseCase checkUserUseCase,
        required LoginUserUseCase loginUserUseCase,
        required LocalStorage localStorage,
        required LogoutUseCase logoutUseCase,
        required RegisterUserUseCase registerUserUseCase,
      })  : _firebaseAuthService = firebaseAuthService,
        _checkUserUseCase = checkUserUseCase,
        _loginUserUseCase = loginUserUseCase,
        _localStorage = localStorage,
        _logoutUseCase = logoutUseCase,
        _registerUserUseCase = registerUserUseCase;

  // Showing loading for send button
  bool sendingOTPStatus = false;
  bool verifyingOTPStatus = false;
  bool resendOTPStatus = false;

  final _timeoutDuration = const Duration(minutes: 1);

  // Auth helpers
  String? phoneNumber;
  int? forceResendingToken;
  String? verificationId;

  void _notify() {
    notifyListeners();
  }

  void resetState() {
    _registerLoadingStatus = Status.init;
    notifyListeners();
  }

  Future<UserSession?> checkUser() async {
    final result = await _checkUserUseCase();
    return result.fold((l) {
      // AppAlert.showToast(message: l.message);
      return null;
    }, (r) {
      return r;
    });
  }

  Future<void> sentOTP({
    required String number,
    required void Function(String, int?) phoneCodeSent,
  }) async {
    sendingOTPStatus = true;
    phoneNumber = number;
    _notify();
    await _executeWithLoadingState(
          () async {
        await _firebaseAuthService.sendOtp(
          number,
          _timeoutDuration,
          _handleAuthError,
          _handleAuthSuccess,
              (verifyId, resendingToken) {
            forceResendingToken = resendingToken;
            verificationId = verifyId;
            _notify();
            phoneCodeSent(verifyId, resendingToken);
          },
          _handleTimeout,
        );
      },
      onComplete: () async {
        await Future.delayed(const Duration(seconds: 1));
        sendingOTPStatus = false;
        _notify();
      },
    );
  }

  Future<void> resendOTP({
    required String phoneNumber,
    required String verificationId,
    required int resendToken,
  }) async {
    resendOTPStatus = true;
    _notify();
    await _executeWithLoadingState(
          () async {
        await _firebaseAuthService.resendOtp(
          phoneNumber,
          _timeoutDuration,
          verificationId,
          resendToken,
          _handleAuthError,
          _handleAuthSuccess,
              (verifyId, resendingToken) {
            forceResendingToken = resendingToken;
            verificationId = verifyId;
            _notify();
            AppAlert.showToast(message: "OTP Sent!");
          },
          _handleTimeout,
        );
      },
      onComplete: () {
        resendOTPStatus = false;
        _notify();
      },
    );
  }

  Future<void> verifyOTP({
    required String verifyId,
    required String smsCode,
    required void Function(bool isNewUser) onVerified,
  }) async {
    verifyingOTPStatus = true;
    _notify();

    await _executeWithLoadingState(
          () async {
        try {
          final UserCredential userCreds =
          await _firebaseAuthService.verifyAndLogin(verifyId, smsCode);
          final user = userCreds.user;

          if (user == null) {
            AppAlert.showToast(message: 'Couldn\'t login');
            return;
          }

          _logUserDetails(user, userCreds.credential?.accessToken);

          final userIdToken = await user.getIdToken();
          if (userIdToken == null) {
            AppAlert.showToast(message: 'Couldn\'t login');
            return;
          }

          final logged =
          await login(userIdToken: userIdToken, userUID: user.uid);
          if (logged) {

            if (phoneNumber != null && phoneNumber!.isNotEmpty) {
              await _localStorage.write(
                SecureStorageItem(key: StorageKey.mobile, value: phoneNumber!),
              );
            }

            final isNewUser =
                await _localStorage.readBool(StorageKey.isNewUser) ?? false;

            onVerified(isNewUser);
          } else {
            AppAlert.showToast(message: 'Login failed after OTP verification');
          }
        } catch (e) {
          LogUtility.error('Error during OTP verification: $e');
          AppAlert.showToast(message: 'Couldn\'t login');
        }
      },
      onComplete: _resetVerificationState,
    );
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogle({
    required BuildContext context,
    required void Function(bool isNewUser) onVerified,
  }) async {
    _setLoading(true);
    try {

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final UserCredential? credential =
      await _firebaseAuthService.signInWithGoogle();

      if (credential == null || credential.user == null) {
        AppAlert.showToast(message: "Google Sign-In cancelled.");
        return;
      }

      final user = credential.user!;
      final idToken = await user.getIdToken();

      if (idToken == null) {
        AppAlert.showToast(message: "Unable to fetch ID token.");
        return;
      }

      _logUserDetails(user, credential.credential?.accessToken);

      final logged = await login(userIdToken: idToken, userUID: user.uid);

      if (logged) {

        if (user.email != null && user.email!.isNotEmpty) {
          await _localStorage.write(
            SecureStorageItem(key: StorageKey.email, value: user.email!),
          );
        }

        final isNewUser =
            await _localStorage.readBool(StorageKey.isNewUser) ?? false;
        onVerified(isNewUser);
      } else {
        AppAlert.showToast(message: "Login failed after Google Sign-In.");
      }
    } catch (e) {
      LogUtility.error("Google Sign-In error: $e");
      AppAlert.showToast(message: "Google Sign-In failed. Please try again.");
    } finally {
      _setLoading(false);
    }
  }





  Future<void> _logUserDetails(User? user, String? accessToken) async {
    LogUtility.info('USER :: ${user?.uid}');
    LogUtility.info('USER ACCESS TOKEN :: $accessToken');

    final userIdToken = await user?.getIdToken();
    LogUtility.info('USER USER ID TOKEN :: $userIdToken');

    LogUtility.info('USER refresh TOKEN :: ${user?.refreshToken}');
  }


  void _resetVerificationState() {
    // verificationId = null;
    // phoneNumber = null;
    forceResendingToken = null;
    verifyingOTPStatus = false;
    _notify();
  }

  Future<User?> getUser() async {
    return _firebaseAuthService.getUser();
  }

  Future<void> _executeWithLoadingState(
      Future<void> Function() action, {
        required VoidCallback onComplete,
      }) async {
    try {
      await action();
    } catch (e) {
      LogUtility.error('Error: $e');
      AppAlert.showToast(message: "An error occurred!");
    } finally {
      onComplete();
    }
  }

  void _handleAuthError(FirebaseAuthException error) {
    LogUtility.error('firebase_auth_error : $error');
    AppAlert.showToast(message: error.message ?? "Something went wrong!");
  }

  void _handleAuthSuccess(PhoneAuthCredential phoneAuthCredential) {
    LogUtility.error(
        'firebase_auth_success : ${phoneAuthCredential.verificationId}');
    AppAlert.showToast(message: phoneAuthCredential.smsCode ?? "OTP SENT!");
  }

  void _handleTimeout(String verificationId) {
    LogUtility.error('firebase_auth_timeout : $verificationId');
  }

  Future<bool> login(
      {required String userIdToken, required String userUID}) async {
    final results =
    await _loginUserUseCase(userIdToken: userIdToken, userUID: userUID);
    LogUtility.info('Login results: $results');
    return results.fold((l) {
      AppAlert.showToast(message: l.message);
      return false;
    }, (r) {
      AppAlert.showToast(
        message: r.message,
      );
      return true;
    });
  }

  Future<bool> logout() async {
    return await _logoutUseCase().then(
          (value) => value.fold(
            (l) {
          AppAlert.showToast(message: l.message);
          return false;
        },
            (r) async {
          await _firebaseAuthService.logout();
          await GoogleSignIn().signOut();
          AppAlert.showToast(message: r.message);
          return true;
        },
      ),
    );
  }



  Status _registerLoadingStatus = Status.init;
  Status get registerLoadingStatus => _registerLoadingStatus;

  Future<void> signup(BuildContext context,
      {required UserSignUpForm userSignUpFormData,
        required VoidCallback onSuccess}) async {
    log('User data: ${userSignUpFormData.toString()}');
    _registerLoadingStatus = Status.loading;
    _notify();
    final result =
    await _registerUserUseCase(userSignUpFormData: userSignUpFormData);

    result.fold((l) {
      _registerLoadingStatus = Status.failure;
      _notify();
      AppAlert.showToast(message: l.message);
    }, (r) {
      _registerLoadingStatus = Status.success;
      _notify();
      AppAlert.showToast(message: r.message);
      onSuccess();
    });
  }
}


