class Api {
  static const String _dev = 'https://test-api-kqss.onrender.com';
  static const String _prod = 'https://test-api-kqss.onrender.com';
  static const String _stage = 'https://test-api-kqss.onrender.com';

  static const String _baseUrl = _dev;

  static const String user = '$_baseUrl/user';
  static const String register = user;

  static String getUser(String firebaseId) => '$user/$firebaseId';

  static String deleteUser(String firebaseId) => '$user/$firebaseId';

  static String updateUser(String firebaseId) => '$user/$firebaseId';

  static String getSchemeId(int schemeId, String firebaseId) =>
      '$_baseUrl/schemes/$schemeId?firebase_id=$firebaseId';

  static String rateScheme(int schemeId) => '$_baseUrl/schemes/$schemeId/rate';

  static String createBookmark() => '$_baseUrl/bookmarks';

  static String deleteBookmark(int bookmarkId) =>
      '$_baseUrl/bookmarks/$bookmarkId';

  static String getBookmark(int userId, int page) =>
      '$_baseUrl/bookmarks?user_id=$userId&page=$page&per_page=10';

  static String getTopRatedScheme() => '$_baseUrl/recommendations';

  static String getScheme({
    required String query,
    required int page,
    required String category,
    required String gender,
    required String city,
    required double income_max,
    bool? differently_abled,
    bool? minority,
    bool? bpl_category,
  }) {
    final queryParams = <String, String>{
      'q': query,
      'page': page.toString(),
      'per_page': '10',
      'category': category,
      'gender': gender,
      'city': city,
      'income_max': income_max.toString(),
      if (differently_abled != null)
        'differently_abled': differently_abled.toString(),
      if (minority != null)
        'minority': minority.toString(),
      if (bpl_category != null)
        'bpl_category': bpl_category.toString(),
    };

    final uri = Uri.https(
        'test-api-kqss.onrender.com', '/schemes/search/enhanced', queryParams);
    return uri.toString();
  }
}
