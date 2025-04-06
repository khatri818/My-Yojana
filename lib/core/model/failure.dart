import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object?> get props => [message];

  const Failure({required this.message});

  final String message;
}
