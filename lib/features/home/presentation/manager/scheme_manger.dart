import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/enum/status.dart';
import '../../domain/entities/scheme.dart';
import '../../domain/use_cases/get_scheme_uecase.dart';


class SchemeManager with ChangeNotifier {

  // UseCases
  final GetSchemeUseCase _getSchemeUseCase;

  SchemeManager(
      {
        required GetSchemeUseCase getSchemeUseCase,
      })  :
        _getSchemeUseCase = getSchemeUseCase;

  int _page = 1;
  int get pageN => _page;

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  void _notify() {
    notifyListeners();
  }

  String searchReleaseQuery = '';
  String _category = '';
  String _gender = '';
  String _city = '';
  double _income_max = 0.0;
  bool _differently_abled = false;
  bool _minority = false;
  bool _bpl_category = false;

  Timer? _debounceTimer;

  void resetState() {
    _page = 1;
    _hasMoreData = true;
    _schemeLoadingStatus = Status.loading;
    _schemePaginationLoadingStatus = Status.loading;
    scheme?.clear();
    notifyListeners();
  }

  List<Scheme>? scheme;

  Status _schemeLoadingStatus = Status.loading;
  Status get schemeLoadingStatus => _schemeLoadingStatus;

  Status _schemePaginationLoadingStatus = Status.loading;
  Status get schemePaginationLoadingStatus =>
      _schemePaginationLoadingStatus;


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

      if (r.isNotEmpty) {
        _page += 1;
      }

      if (r.length < 10) {
        _hasMoreData = false;
      }

      _schemeLoadingStatus = Status.success;
      _schemePaginationLoadingStatus = Status.success;
      notifyListeners();
    });
  }


  void setFilter(category, gender, city, income_max, differently_abled, minority, bpl_category) {
    resetState();
    _category = category;
    _gender = gender;
    _city= city;
    _income_max=income_max;
    _differently_abled= differently_abled;
    _minority=minority;
    _bpl_category=bpl_category;
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


