import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/scheme.dart';
import '../../domain/use_cases/create_bookmark_usecase.dart';
import '../../domain/use_cases/get_scheme_id_usecase.dart';
import '../../domain/use_cases/get_scheme_uecase.dart';
import '../../domain/use_cases/rate_scheme_usecase.dart';

class SchemeManager with ChangeNotifier {
  // UseCases
  final GetSchemeUseCase _getSchemeUseCase;
  final GetSchemeIdUseCase _getSchemeIdUseCase;
  final RateSchemeUseCase _rateSchemeUseCase;
  final CreateBookmarkUseCase _createBookmarkUseCase;

  SchemeManager({
    required CreateBookmarkUseCase createBookmarkUseCase,
    required GetSchemeUseCase getSchemeUseCase,
    required GetSchemeIdUseCase getSchemeIdUseCase,
    required RateSchemeUseCase rateSchemeUseCase,
  })  : _createBookmarkUseCase = createBookmarkUseCase,
        _getSchemeUseCase = getSchemeUseCase,
        _getSchemeIdUseCase = getSchemeIdUseCase,
        _rateSchemeUseCase = rateSchemeUseCase;

  int _page = 1;
  int get pageN => _page;

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  String searchReleaseQuery = '';
  String _category = '';
  String _gender = '';
  String _city = '';
  double _income_max = 0.0;
  bool _differently_abled = false;
  bool _minority = false;
  bool _bpl_category = false;

  Timer? _debounceTimer;

  List<Scheme>? scheme;

  Scheme? selectedScheme;

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


  void _notify() {
    notifyListeners();
  }

  void resetState() {
    _page = 1;
    _hasMoreData = true;
    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;

    scheme?.clear();
    _category = '';
    _gender = '';
    _city = '';
    _income_max = 0.0;
    _differently_abled = false;
    _minority = false;
    _bpl_category = false;
    searchReleaseQuery = '';

    notifyListeners();
  }

  Future<void> getScheme({bool showLoading = false}) async {
    _setLoadingStatus(showLoading);
    notifyListeners();

    final results = await _getSchemeUseCase(
      page: _page,
      category: _category,
      gender: _gender,
      city: _city,
      income_max: _income_max,
      differently_abled: _differently_abled,
      minority: _minority,
      bpl_category: _bpl_category,
    );

    results.fold((l) {
      _handleFailure();
    }, (r) {
      if (_page == 1) {
        scheme = r;
      } else {
        scheme?.addAll(r);
      }

      if (r.isNotEmpty) _page += 1;
      if (r.length < 10) _hasMoreData = false;

      _schemeLoadingStatus = Status.success;
      _schemePaginationLoadingStatus = Status.success;
      notifyListeners();
    });
  }

  /// Fetches a single scheme by ID and returns it
  Future<Scheme?> getSchemeId(int schemeId) async {
    _schemeByIdStatus = Status.loading;
    notifyListeners();

    final result = await _getSchemeIdUseCase(schemeId: schemeId);

    return result.fold((l) {
      _schemeByIdStatus = Status.failure;
      selectedScheme = null;
      notifyListeners();
      return null;
    }, (r) {
      selectedScheme = r;
      _schemeByIdStatus = Status.success;
      notifyListeners();
      return r;
    });
  }

  Future<String?> createBookmark({
    required String firebaseId,
    required int schemeId,
  }) async {
    try {
      _schemeBookmarkStatus = Status.loading;
      notifyListeners();

      final result = await _createBookmarkUseCase(
        firebaseId: firebaseId,
        schemeId: schemeId,
      );

      final response = result.fold(
            (failure) {
          _schemeBookmarkStatus = Status.failure;
          notifyListeners();
          return failure.message;
        },
            (success) {
          _schemeBookmarkStatus = Status.success;
          getSchemeId(schemeId); // Refresh scheme info (e.g. to show bookmark ID)
          notifyListeners();
          return null;
        },
      );

      return response;
    } catch (e) {
      _schemeBookmarkStatus = Status.failure;
      notifyListeners();
      return "Something went wrong: ${e.toString()}";
    }
  }


  /// Submits a rating for a scheme
  Future<String?> rateScheme({
    required int schemeId,
    required int userId,
    required double rating,
  }) async {
    try {
      _schemeRatingStatus = Status.loading;
      notifyListeners();

      final result = await _rateSchemeUseCase(
        schemeId: schemeId,
        userId: userId,
        rating: rating,
      );

      final response = result.fold(
            (failure) {
          _schemeRatingStatus = Status.failure;
          notifyListeners();
          return failure.message;
        },
            (success) {
          _schemeRatingStatus = Status.success;
          getSchemeId(schemeId); // Refresh the scheme
          notifyListeners();
          return null;
        },
      );

      return response;
    } catch (e) {
      _schemeRatingStatus = Status.failure;
      notifyListeners();
      return "Something went wrong: \${e.toString()}";
    }
  }

  /// Backward-compatible setter that populates and fetches schemes
  void setFilter(
      String category,
      String gender,
      String city,
      double income_max,
      bool differently_abled,
      bool minority,
      bool bpl_category,
      ) {
    resetState();
    _category = category;
    _gender = gender;
    _city = city;
    _income_max = income_max;
    _differently_abled = differently_abled;
    _minority = minority;
    _bpl_category = bpl_category;
    getScheme(showLoading: true);
  }

  void setSearchQuery(String searchQuery) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      resetState();
      searchReleaseQuery = searchQuery;
      getScheme(showLoading: true);
    });
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
}