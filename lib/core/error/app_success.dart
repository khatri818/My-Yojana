import 'package:equatable/equatable.dart';

abstract class AppSuccess extends Equatable {
  final String message;
  final int? id;
  const AppSuccess({required this.message, this.id});
}

class SuccessMessage extends AppSuccess {
  const SuccessMessage({required super.message, super.id});
  @override
  List<Object?> get props => [message, id];
}
