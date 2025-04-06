import 'package:equatable/equatable.dart';

class CheckUserResponse extends Equatable {
  final bool isUserExists;
  final String message;

  const CheckUserResponse({required this.isUserExists, required this.message});

  @override
  List<Object?> get props => [isUserExists, message];
}
