import 'package:flutter/material.dart';
import 'package:my_yojana/features/user/presentation/pages/user_page.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_user_usecase.dart';

class UserManager with ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserManager({
    required GetUserUseCase getUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _getUserUseCase = getUserUseCase,
        _deleteUserUseCase = deleteUserUseCase;

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
}
