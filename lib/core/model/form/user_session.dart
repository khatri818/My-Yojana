import 'package:equatable/equatable.dart';

class UserSession extends Equatable {
  final String token;
  final bool isNewUser;

  const UserSession({
    required this.token,
    required this.isNewUser,
  });

  @override
  List<Object?> get props => [
    token,
    isNewUser,
  ];
}
