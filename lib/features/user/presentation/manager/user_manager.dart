import 'package:flutter/material.dart';
import 'package:my_yojana/features/user/presentation/pages/user_page.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/user.dart';

class UserManager with ChangeNotifier {
  final GetUserUseCase _getUserUseCase;

  UserManager({required GetUserUseCase getUserUseCase})
      : _getUserUseCase = getUserUseCase;

  User? user;

  Status _userLoadingStatus = Status.loading;
  Status get userLoadingStatus => _userLoadingStatus;

  void getUser(String firebaseId) async {
    final results = await _getUserUseCase(firebaseId: firebaseId);
    results.fold((l) {
      _userLoadingStatus = Status.failure;
      notifyListeners();
    }, (r) {
      user = r;
      _userLoadingStatus = Status.success;
      notifyListeners();
    });
  }
}
