import 'package:dio/dio.dart';

import 'log_utility.dart';

class CustomInterceptor extends Interceptor {
  Map<String, DateTime> requestStartTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestLog = '''
    ====================== Request ======================
    URL: ${options.uri}
    Method: ${options.method}
    Headers: ${options.headers}
    Body: ${options.data}
    ''';
    LogUtility.customLog(ColorText.green(requestLog), name: 'Request');

    requestStartTimes[options.uri.toString()] = DateTime.now();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final startTime = requestStartTimes[response.requestOptions.uri.toString()];
    final endTime = DateTime.now();

    final responseLog = '''
    ====================== Response ======================
    URL: ${response.realUri}
    Status Code: ${response.statusCode}
    Headers: ${response.headers}
    ''';
    LogUtility.customLog(ColorText.yellow(responseLog), name: 'Response');

    // final decodedData = await compute(decodeJson, response.data.toString());

    // final decodeEndTime = DateTime.now();
    final requestDuration = endTime.difference(startTime!).inMilliseconds;
    // final decodeDuration = decodeEndTime.difference(endTime).inMilliseconds;

    LogUtility.customLog(ColorText.yellow('Request took: $requestDuration ms'),
        name: 'Performance');
    // LogUtility.customLog(ColorText.yellow('Decoding took: $decodeDuration ms'),
    //     name: 'Performance');

    // Add decoded data to response
    // response.data = decodedData;
    LogUtility.customLog(ColorText.yellow(response.data.toString()),
        name: 'BODY');
    LogUtility.customLog(ColorText.yellow(response.statusCode.toString()),
        name: 'StatusCode');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = requestStartTimes[err.requestOptions.uri.toString()];
    final endTime = DateTime.now();

    final errorLog = '''
    ====================== Error ======================
    URL: ${err.requestOptions.uri}
    Status Code: ${err.response?.statusCode}
    Error: ${err.message}
    Response: ${err.response?.data}
    Stack Trace: ${err.stackTrace}
    ''';
    LogUtility.customLog(ColorText.red(errorLog), name: 'Error');

    if (startTime != null) {
      final requestDuration = endTime.difference(startTime).inMilliseconds;
      LogUtility.customLog(ColorText.red('Request took: $requestDuration ms'),
          name: 'Performance');
    }

    handler.next(err);
  }
}
