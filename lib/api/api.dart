class Api {
  static const String _dev = 'https://test-api-kqss.onrender.com';
  static const String _prod = 'https://test-api-kqss.onrender.com';
  static const String _stage = 'https://test-api-kqss.onrender.com';

  static const String _baseUrl = _dev;

  static const String user = '$_baseUrl/user';
  static const String register = user;

  static String getUser(String firebaseId) => '$user/$firebaseId';
  static String getScheme = '$_baseUrl/schemes';
}
