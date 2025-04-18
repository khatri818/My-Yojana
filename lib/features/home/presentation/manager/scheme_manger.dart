import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/scheme.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/use_cases/create_bookmark_usecase.dart';
import '../../domain/use_cases/delete_bookmark_usecase.dart';
import '../../domain/use_cases/get_scheme_id_usecase.dart';
import '../../domain/use_cases/get_scheme_uecase.dart';
import '../../domain/use_cases/rate_scheme_usecase.dart';
import '../../domain/use_cases/get_top_rated_scheme_usecase.dart';
import '../../domain/use_cases/get_bookmark_usecase.dart';

class SchemeManager with ChangeNotifier {
  final GetSchemeUseCase _getSchemeUseCase;
  final GetSchemeIdUseCase _getSchemeIdUseCase;
  final RateSchemeUseCase _rateSchemeUseCase;
  final CreateBookmarkUseCase _createBookmarkUseCase;
  final DeleteBookmarkUseCase _deleteBookmarkUseCase;
  final GetTopRatedSchemeUseCase _getTopRatedSchemeUseCase;
  final GetBookmarkUseCase _getBookmarkUseCase;

  SchemeManager({
    required CreateBookmarkUseCase createBookmarkUseCase,
    required DeleteBookmarkUseCase deleteBookmarkUseCase,
    required GetSchemeUseCase getSchemeUseCase,
    required GetSchemeIdUseCase getSchemeIdUseCase,
    required RateSchemeUseCase rateSchemeUseCase,
    required GetTopRatedSchemeUseCase getTopRatedSchemeUseCase,
    required GetBookmarkUseCase getBookmarkUseCase,
  })  : _createBookmarkUseCase = createBookmarkUseCase,
        _deleteBookmarkUseCase = deleteBookmarkUseCase,
        _getSchemeUseCase = getSchemeUseCase,
        _getSchemeIdUseCase = getSchemeIdUseCase,
        _rateSchemeUseCase = rateSchemeUseCase,
        _getTopRatedSchemeUseCase = getTopRatedSchemeUseCase,
        _getBookmarkUseCase = getBookmarkUseCase;

  List<Scheme>? scheme;
  Scheme? selectedScheme;

  List<Scheme>? _topRatedSchemes;
  List<Scheme>? get topRatedSchemes => _topRatedSchemes;

  List<Bookmark>? _bookmarks;
  List<Bookmark>? get bookmarks => _bookmarks;

  List<Scheme>? _bookmarkSchemes;
  List<Scheme>? get bookmarkSchemes => _bookmarkSchemes;

  int _page = 1;
  bool _hasMoreData = true;
  Timer? _debounceTimer;

  int _bookmarkPage = 1;
  bool _hasMoreBookmarks = true;
  bool get hasMoreBookmarkSchemes => _hasMoreBookmarks;

  String searchReleaseQuery = '';
  String _category = '';
  String _gender = '';
  String _city = '';
  double _income_max = 0.0;
  bool? _differently_abled;
  bool? _minority;
  bool? _bpl_category;

  Status _schemeLoadingStatus = Status.loading;
  Status get schemeLoadingStatus => _schemeLoadingStatus;

  Status _schemePaginationLoadingStatus = Status.loading;
  Status get schemePaginationLoadingStatus => _schemePaginationLoadingStatus;

  Status _schemeByIdStatus = Status.loading;
  Status get schemeByIdStatus => _schemeByIdStatus;

  Status _schemeRatingStatus = Status.init;
  Status get schemeRatingStatus => _schemeRatingStatus;

  Status _schemeBookmarkStatus = Status.init;
  Status get schemeBookmarkStatus => _schemeBookmarkStatus;

  Status _schemeDeleteBookmarkStatus = Status.init;
  Status get schemeDeleteBookmarkStatus => _schemeDeleteBookmarkStatus;

  Status _bookmarkFetchStatus = Status.init;
  Status get bookmarkFetchStatus => _bookmarkFetchStatus;

  Status _topRatedSchemeStatus = Status.init;
  Status get topRatedSchemeStatus => _topRatedSchemeStatus;

  void _notify() => notifyListeners();

  void resetState() {
    _page = 1;
    _hasMoreData = true;
    scheme?.clear();
    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;
    notifyListeners();
  }

  void clearFilters() {
    _category = '';
    _gender = '';
    _city = '';
    _income_max = 0.0;

    _differently_abled = null;
    _minority = null;
    _bpl_category = null;

    searchReleaseQuery = '';
    _page = 1;
    _hasMoreData = true;
    scheme?.clear();

    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;

    notifyListeners();
  }


  void applyFilterFromUserProfile({
    required String? gender,
    required String? city,
    required double? incomeMax,
    required bool? differentlyAbled,
    required bool? minority,
    required bool? bplCategory,
  }) {
    _gender = gender ?? '';
    _city = city ?? '';
    _income_max = incomeMax ?? 0.0;
    _differently_abled = differentlyAbled;
    _minority = minority;
    _bpl_category = bplCategory;

    _page = 1;
    _hasMoreData = true;
    scheme?.clear();
    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;

    getScheme(showLoading: true);
  }


  Future<void> getScheme({bool showLoading = false}) async {
    _setLoadingStatus(showLoading);
    notifyListeners();

    final results = await _getSchemeUseCase(
      query: searchReleaseQuery,
      page: _page,
      category: _category,
      gender: _gender,
      city: _city,
      income_max: _income_max,
      differently_abled: _differently_abled,
      minority: _minority,
      bpl_category: _bpl_category,
    );

    results.fold(
          (_) => _handleFailure(),
          (r) {
        final existingIds = scheme?.map((s) => s.id).toSet() ?? {};
        final filteredResults = r.where((newScheme) => !existingIds.contains(newScheme.id)).toList();

        if (_page == 1) {
          scheme = filteredResults;
        } else {
          scheme?.addAll(filteredResults);
        }

        if (filteredResults.isNotEmpty) _page += 1;
        if (r.length < 10) _hasMoreData = false;

        _schemeLoadingStatus = Status.success;
        _schemePaginationLoadingStatus = Status.success;
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String searchQuery) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _page = 1;
      _hasMoreData = true;
      scheme?.clear();
      _schemeLoadingStatus = Status.loading;
      _schemePaginationLoadingStatus = Status.loading;

      searchReleaseQuery = searchQuery;
      getScheme(showLoading: true);
    });
  }


  void setFilter(
      String category,
      String gender,
      String city,
      double income_max,
      bool? differently_abled,
      bool? minority,
      bool? bpl_category,
      ) {
    _page = 1;
    _hasMoreData = true;
    scheme?.clear();
    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;

    _category = category;
    _gender = gender;
    _city = city;
    _income_max = income_max;
    _differently_abled = differently_abled;
    _minority = minority;
    _bpl_category = bpl_category;

    getScheme(showLoading: true);
  }


  Future<Scheme?> getSchemeId(int schemeId, String firebaseId) async {
    _schemeByIdStatus = Status.loading;
    notifyListeners();

    final result = await _getSchemeIdUseCase(schemeId: schemeId, firebaseId: firebaseId);

    return result.fold(
          (_) {
        _schemeByIdStatus = Status.failure;
        selectedScheme = null;
        notifyListeners();
        return null;
      },
          (scheme) {
        selectedScheme = scheme;
        _schemeByIdStatus = Status.success;
        notifyListeners();
        return scheme;
      },
    );
  }

  Future<String?> createBookmark({
    required String firebaseId,
    required int schemeId,
    required int userId
  }) async {
    _schemeBookmarkStatus = Status.loading;
    notifyListeners();  // Notify UI that the bookmark creation process is starting

    final result = await _createBookmarkUseCase(firebaseId: firebaseId, schemeId: schemeId);

    return result.fold(
          (failure) {
        _schemeBookmarkStatus = Status.failure;
        notifyListeners();  // Notify UI of failure
        return failure.message;
      },
          (_) {
        _schemeBookmarkStatus = Status.success;
        // Refresh bookmarks after adding a new one
        getBookmarks(userId: userId, page: 1);  // Make sure to refresh the bookmark list
        notifyListeners();  // Notify UI of success
        return null;
      },
    );
  }

  Future<String?> deleteBookmark({
    required String firebaseId,
    required int bookmarkId,
    required int userId
  }) async {
    _schemeDeleteBookmarkStatus = Status.loading;
    notifyListeners();  // Notify UI that the bookmark deletion process is starting

    final result = await _deleteBookmarkUseCase(firebaseId: firebaseId, bookmarkId: bookmarkId);

    return result.fold(
          (failure) {
        _schemeDeleteBookmarkStatus = Status.failure;
        notifyListeners();  // Notify UI of failure
        return failure.message;
      },
          (_) {
        _schemeDeleteBookmarkStatus = Status.success;
        // Refresh bookmarks after deletion
        getBookmarks(userId: userId, page: 1);  // Refresh the list after removing a bookmark
        notifyListeners();  // Notify UI of success
        return null;
      },
    );
  }

  Future<void> getBookmarks({required int userId, int page = 1}) async {
    _bookmarkFetchStatus = Status.loading;
    notifyListeners();  // Notify UI that the bookmark fetching process is starting

    final result = await _getBookmarkUseCase(userId: userId, page: page);

    result.fold(
          (failure) {
        _bookmarkFetchStatus = Status.failure;
        _hasMoreBookmarks = false;
        notifyListeners();  // Notify UI of failure
      },
          (bookmarkList) {
        if (page == 1) {
          _bookmarks = bookmarkList;
        } else {
          _bookmarks ??= [];
          _bookmarks!.addAll(bookmarkList);
        }

        _hasMoreBookmarks = bookmarkList.length >= 10;
        _bookmarkPage = page;
        _bookmarkFetchStatus = Status.success;
        notifyListeners();  // Notify UI that bookmarks have been fetched successfully
      },
    );
  }


  Future<String?> rateScheme({
    required int schemeId,
    required int userId,
    required double rating,
  }) async {
    _schemeRatingStatus = Status.loading;
    notifyListeners();

    final result = await _rateSchemeUseCase(
      schemeId: schemeId,
      userId: userId,
      rating: rating,
    );

    return result.fold(
          (failure) {
        _schemeRatingStatus = Status.failure;
        notifyListeners();
        return failure.message;
      },
          (_) {
        _schemeRatingStatus = Status.success;
        notifyListeners();
        getTopRatedScheme();
        getBookmarks(userId: userId);
        return null;
      },
    );
  }

  Future<void> getTopRatedScheme() async {
    _topRatedSchemeStatus = Status.loading;
    notifyListeners();

    final result = await _getTopRatedSchemeUseCase();

    result.fold(
          (failure) {
        _topRatedSchemes = null;
        _topRatedSchemeStatus = Status.failure;
      },
          (schemes) {
        _topRatedSchemes = schemes;
        _topRatedSchemeStatus = Status.success;
      },
    );

    notifyListeners();
  }



  void _setLoadingStatus(bool showLoading) {
    if (showLoading) {
      _schemeLoadingStatus = Status.loading;
    } else {
      _schemePaginationLoadingStatus = Status.loading;
    }
  }

  void _handleFailure() {
    _schemePaginationLoadingStatus = Status.failure;
    _schemeLoadingStatus = Status.failure;
    notifyListeners();
  }

  int get pageN => _page;
  bool get hasMoreData => _hasMoreData;
}
