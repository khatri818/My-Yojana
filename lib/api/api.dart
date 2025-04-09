class Api {
  static const String _dev = 'https://test-api-kqss.onrender.com';
  static const String _prod = 'https://test-api-kqss.onrender.com';
  static const String _stage = 'https://test-api-kqss.onrender.com';

  static const String _baseUrl = _dev;

  static const String user = '$_baseUrl/user';
  static const String register = user;

  static String getUser(String firebaseId) => '$user/$firebaseId';
  static String getScheme({required int page,required String category, required String gender, required String city, required double income_max, required bool differently_abled, required bool minority, required bool bpl_category}) =>
      '$_baseUrl/schemes?page=$page&per_page=10&category=$category&gender=$gender&city=$city&income_max=$income_max&differently_abled=$differently_abled&minority=$minority&bpl_category=$bpl_category';
}
