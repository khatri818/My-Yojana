import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_yojana/core/model/form/user_sign_up_form.dart';
import 'package:my_yojana/features/user/domain/usecases/update_user_usecase.dart';
import 'package:my_yojana/features/user/presentation/pages/user_page.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/app_success.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_user_usecase.dart';

class UserManager with ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  UserManager({
    required GetUserUseCase getUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required UpdateUserUseCase updateUserUseCase
  })  : _getUserUseCase = getUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _updateUserUseCase = updateUserUseCase;

  User? user;

  Status _userLoadingStatus = Status.loading;
  Status get userLoadingStatus => _userLoadingStatus;

  Future<void> getUser(String firebaseId) async {
    final results = await _getUserUseCase(firebaseId: firebaseId);
    results.fold((l) {
      _userLoadingStatus = Status.failure;
    }, (r) {
      user = r;
      _userLoadingStatus = Status.success;
    });
    notifyListeners();
  }

  Future<bool> deleteUser(String firebaseId) async {
    final result = await _deleteUserUseCase(firebaseId: firebaseId);
    return result.fold((l) => false, (r) => true);
  }

  Future<Either<AppError, AppSuccess>> updateUser({
    required String firebaseId,
    required UserSignUpForm userSignUpForm,
  }) async {
    _userLoadingStatus = Status.loading;
    notifyListeners();

    final result = await _updateUserUseCase(
      firebaseId: firebaseId,
      userSignUpForm: userSignUpForm,
    );

    result.fold(
          (l) {
        _userLoadingStatus = Status.failure;
      },
          (r) {
        _userLoadingStatus = Status.success;
      },
    );

    notifyListeners();
    return result;
  }



}