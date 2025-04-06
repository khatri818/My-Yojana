import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../utils/type_def.dart';

abstract class AppError extends Equatable {
  final String message;
  const AppError({required this.message});
}

class ErrorMessage extends AppError {
  const ErrorMessage({required super.message});

  @override
  List<Object?> get props => [message];
}

AppTypeResponse<dynamic> handleApiResponse(dynamic result) async {
  final statusCode = result.statusCode;
  final data = jsonDecode(result.data);

  if (statusCode == null || statusCode >= 400) {
    return Left(ErrorMessage(
        message: data['message'] ?? data['error'] ?? 'Something went wrong!'));
  }

  return Right(data);
}
