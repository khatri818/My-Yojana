
import 'package:dartz/dartz.dart';

import '../error/app_error.dart';
import '../error/app_success.dart';
import 'http_utils.dart';

typedef AppSuccessResponseEither = Either<AppError, AppSuccess>;
typedef AppTypeResponseEither<T> = Either<AppError, T>;
typedef AppHttpResponse = Future<Either<AppError, AppResponse>>;
typedef AppSuccessResponse = Future<Either<AppError, AppSuccess>>;
typedef AppTypeResponse<T> = Future<Either<AppError, T>>;