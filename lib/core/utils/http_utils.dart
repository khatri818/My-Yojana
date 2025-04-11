import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../constant/app_text.dart';
import '../constant/storage_key.dart';
import '../error/app_error.dart';
import '../services/storage_service.dart';
import 'type_def.dart';

abstract class AppHttp {
  AppHttpResponse post({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = false,
    Map<String, dynamic>? queryParameters,
  });

  AppHttpResponse get({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = false,
    Map<String, dynamic>? queryParameters,
  });

  AppHttpResponse update({
    required String path,
    Object? data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  });

  AppHttpResponse delete({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = false,
    Map<String, dynamic>? queryParameters,
  });

  AppHttpResponse put({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = false,
    Map<String, dynamic>? queryParameters,
  });

  AppHttpResponse putFile({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = false,
    Map<String, dynamic>? queryParameters,
  });
}

class AppHttpImpl extends AppHttp {
  final Dio _dio;
  final LocalStorage _storage;

  AppHttpImpl(this._dio, this._storage);

  @override
  AppHttpResponse delete({
    required String path,
    Object? data,
    Options? options,
    bool withOutToken = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //LogUtility.customLog(path, name: "API");

      late final Options? tokenHead;
      if (!withOutToken) {
        tokenHead = await _headerWithToken();
        // //LogUtility.customLog(tokenHead, name: "REQUEST HEADERS");

        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      //LogUtility.customLog(data, name: "REQUEST BODY");
      final response = await _dio.delete(
        path,
        data: data,
        options: withOutToken ? options : tokenHead!,
        queryParameters: queryParameters,
      );
      //LogUtility.customLog(response.statusCode, name: "STATUS-CODE");
      // //LogUtility.customLog(response.headers, name: "RESPONSE HEADERS");
      //LogUtility.customLog(response.data, name: "RESPONSE BODY");
      return Right(AppResponse.fromDioResponse(response));
    } on DioException catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  @override
  AppHttpResponse get(
      {required String path,
      Object? data,
      Options? options,
      bool withOutToken = true,
      Map<String, dynamic>? queryParameters}) async {
    try {
      late final Options? tokenHead;
      if (!withOutToken) {
        tokenHead = await _headerWithToken();

        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      final response = await _dio.get(
        path,
        data: data,
        options: withOutToken ? options : tokenHead!,
        queryParameters: queryParameters,
      );
      return Right(AppResponse.fromDioResponse(response));
    } on DioException catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  @override
  AppHttpResponse post(
      {required String path,
      Object? data,
      Options? options,
      bool withOutToken = true,
      Map<String, dynamic>? queryParameters}) async {
    try {
      //LogUtility.customLog(path, name: "API");
      late final Options? tokenHead;
      if (!withOutToken) {
        tokenHead = await _headerWithToken();
        // //LogUtility.customLog(tokenHead, name: "REQUEST HEADERS");
        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      //LogUtility.customLog(data, name: "REQUEST BODY");
      final response = await _dio.post(
        path,
        data: data,
        options: withOutToken ? options : tokenHead,
        queryParameters: queryParameters,
      );
      //LogUtility.customLog(response.statusCode, name: "STATUS-CODE");
      //LogUtility.customLog(response.data, name: "RESPONSE BODY");
      return Right(AppResponse.fromDioResponse(response));
    } on DioException catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  @override
  AppHttpResponse update(
      {required String path,
      Object? data,
      Options? options,
      bool defaultHeader = true,
      Map<String, dynamic>? queryParameters}) async {
    try {
      //LogUtility.customLog(path, name: "API");

      late final Options? tokenHead;
      if (!defaultHeader) {
        tokenHead = await _headerWithToken();
        // //LogUtility.customLog(tokenHead, name: "REQUEST HEADERS");

        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      //LogUtility.customLog(data, name: "REQUEST BODY");
      final response = await _dio.put(
        path,
        data: data,
        options: defaultHeader ? options : tokenHead,
        queryParameters: queryParameters,
      );
      //LogUtility.customLog(response.statusCode, name: "STATUS-CODE");
      // //LogUtility.customLog(response.headers, name: "RESPONSE HEADERS");
      //LogUtility.customLog(response.data, name: "RESPONSE BODY");
      return Right(AppResponse.fromDioResponse(response));
    } on DioException catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  @override
  AppHttpResponse put(
      {required String path,
      Object? data,
      Options? options,
      bool withOutToken = true,
      Map<String, dynamic>? queryParameters}) async {
    try {
      //LogUtility.customLog(path, name: "API");

      late final Options? tokenHead;
      if (!withOutToken) {
        tokenHead = await _headerWithToken();
        // //LogUtility.customLog(tokenHead, name: "REQUEST HEADERS");

        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      //LogUtility.customLog(data, name: "REQUEST BODY");
      final response = await _dio.put(
        path,
        data: data,
        options: withOutToken ? options : tokenHead,
        queryParameters: queryParameters,
      );
      //LogUtility.customLog(response.statusCode, name: "STATUS-CODE");
      // //LogUtility.customLog(response.headers, name: "RESPONSE HEADERS");
      //LogUtility.customLog(response.data, name: "RESPONSE BODY");
      return Right(AppResponse.fromDioResponse(response));
    } on DioError catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  Future<Options?> _headerWithToken() async {
    final token = await _storage.read(StorageKey.token);
    // final token = await _storage.read(StorageKey.jwtToken);
    if (token != null) {
      return Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'UserUID': ''
        },
      );
    }
    return null;
  }

  @override
  AppHttpResponse putFile(
      {required String path,
      Object? data,
      Options? options,
      bool withOutToken = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      //LogUtility.customLog(path, name: "API");

      late final Options? tokenHead;
      if (!withOutToken) {
        tokenHead = await _headerWithToken();
        if (tokenHead == null) {
          return const Left(ErrorMessage(message: AppText.sessionOut));
        }
      }
      //LogUtility.customLog(data, name: "REQUEST BODY");
      final response = await _dio.post(
        path,
        data: data,
        options: withOutToken ? options : tokenHead,
        queryParameters: queryParameters,
      );
      //LogUtility.customLog(response.statusCode, name: "STATUS-CODE");
      // //LogUtility.customLog(response.headers, name: "RESPONSE HEADERS");
      //LogUtility.customLog(response.data, name: "RESPONSE BODY");
      return Right(AppResponse.fromDioResponse(response));
    } on DioError catch (dioError) {
      return Left(_dioErrorParse(dioError));
    } on SocketException catch (_) {
      return const Left(ErrorResponse.socketException);
    } on FormatException catch (_) {
      return const Left(ErrorResponse.formatException);
    } on TimeoutException catch (_) {
      return const Left(ErrorResponse.timeOutException);
    }
  }

  AppError _dioErrorParse(DioException dioError) {
    if (dioError.response != null) {
      final data = dioError.response!.data;
      final statusCode = dioError.response!.statusCode;
      final statusMessage = dioError.response!.statusMessage;

      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return ErrorMessage(
          message: data['message'] ??
              data['error'] ??
              statusMessage ??
              AppText.somethingWentWrong,
        );
      }
      if (statusCode != null && statusCode >= 500) {
        return const ErrorMessage(message: AppText.serverDown);
      }
      return ErrorMessage(
        message: data['message'] ?? statusMessage ?? AppText.somethingWentWrong,
      );
    } else {
      return ErrorMessage(message: dioError.message ?? AppText.serverDown);
    }
  }
}

class AppResponse {
  dynamic data;
  int? statusCode;
  String? statusMessage;
  Headers headers;

  AppResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
    required this.headers,
  });

  factory AppResponse.fromDioResponse(Response response) {
    return AppResponse(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers,
    );
  }
}
