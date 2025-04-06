import 'dart:async' show Zone;
import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kDebugMode;

class LogUtility {
  static void info(String message) {
    if (kDebugMode) {
      _log(ColorText.white(message), name: 'INFO', level: 200);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _log(ColorText.yellow(message), name: 'WARNING', level: 1000);
    }
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _log(ColorText.red(message),
          name: 'ERROR', level: 2000, error: error, stackTrace: stackTrace);
    }
  }

  static void customLog(dynamic msg, {String name = 'LOG', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _log(
        (msg ?? '').toString(),
        name: name,
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
        level: 0,
      );
    }
  }

  static void _log(String message,
      {DateTime? time,
      int? sequenceNumber,
      int level = 0,
      String name = '',
      Zone? zone,
      Object? error,
      StackTrace? stackTrace}) {
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class ColorText {
  static String black(String value) {
    return '\x1B[30m$value\x1B[0m';
  }

  static String red(String value) {
    return '\x1B[31m$value\x1B[0m';
  }

  static String green(String value) {
    return '\x1B[32m$value\x1B[0m';
  }

  static String yellow(String value) {
    return '\x1B[33m$value\x1B[0m';
  }

  static String blue(String value) {
    return '\x1B[34m$value\x1B[0m';
  }

  static String magenta(String value) {
    return '\x1B[35m$value\x1B[0m';
  }

  static String cyan(String value) {
    return '\x1B[36m$value\x1B[0m';
  }

  static String white(String value) {
    return '\x1B[37m$value\x1B[0m';
  }

  static String other(String value) {
    return '\x1B[0m$value\x1B[0m';
  }

  ///
}

class PrintText {
//!BLACK
  static void printNormalInBlack(String text) {
    if (kDebugMode) {
      print('\x1B[30m$text\x1B[0m');
    }
  }

//!RED
  static void printErrorInRed(String value) {
    if (kDebugMode) {
      print('\x1B[31m$value\x1B[0m');
    }
  }

//!GREEN
  static void printSuccessInGreen(String value) {
    if (kDebugMode) {
      print('\x1B[32m$value\x1B[0m');
    }
  }

//!YELLOW
  static void printWarningInYellow(String value) {
    if (kDebugMode) {
      print('\x1B[33m$value\x1B[0m');
    }
  }

//!BLUE
  static void printInfoInBlue(String value) {
    if (kDebugMode) {
      print('\x1B[34m$value\x1B[0m');
    }
  }

  //!MAGENTA
  static void printActionInMagenta(String value) {
    if (kDebugMode) {
      print('\x1B[35m$value\x1B[0m');
    }
  }

  //!CYAN
  static void printCanceledInCyan(String value) {
    if (kDebugMode) {
      print('\x1B[36m$value\x1B[0m');
    }
  }

  //!WHITE
  static void printNormalInWhite(String value) {
    if (kDebugMode) {
      print('\x1B[37m$value\x1B[0m');
    }
  }

  //!RESET
  static void printResetInReset(String value) {
    if (kDebugMode) {
      print('\x1B[0m$value\x1B[0m');
    }
  }
}
