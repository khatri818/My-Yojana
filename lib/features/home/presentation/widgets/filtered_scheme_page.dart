import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../manager/scheme_manger.dart';
import '../widgets/scheme_item.dart';

class FilteredSchemePage extends StatefulWidget {
  final String category;
  const FilteredSchemePage({super.key, required this.category});

  @override
  State<FilteredSchemePage> createState() => _FilteredSchemePageState();
}

class _FilteredSchemePageState extends State<FilteredSchemePage> {
  final ScrollController _scrollController = ScrollController();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final schemeManager = context.read<SchemeManager>();
      schemeManager.clearFilters(); // Clear any existing filters
      schemeManager.setFilter(
        widget.category, // Apply category filter
        '', '', 0.0,
        false, false, false,
      );
      _hasInitialized = true;
    }
  }

  void _onScroll() {
    final schemeManager = context.read<SchemeManager>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !schemeManager.schemePaginationLoadingStatus.loading &&
        schemeManager.hasMoreData) {
      schemeManager.getScheme(showLoading: false); // Load more schemes when scrolled to the bottom
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final schemeManager = context.read<SchemeManager>();
    schemeManager.resetState();
    schemeManager.setFilter(
      widget.category, '', '', 0.0,
      false, false, false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Schemes'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Consumer<SchemeManager>(
        builder: (context, schemeManager, _) {
          final schemes = schemeManager.scheme;

          // Show loading indicator if data is still being fetched
          if (schemeManager.schemeLoadingStatus == Status.loading &&
              (schemes == null || schemes.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show message if no schemes are found
          else if (schemes == null || schemes.isEmpty) {
            return const Center(child: Text('No schemes found in this category.'));
          }

          // Show the list of schemes when data is available
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16), // 👈 Added spacing here
              itemCount: schemes.length + 1,
              itemBuilder: (context, index) {
                // Show loading indicator at the end if more data is being fetched
                if (index == schemes.length) {
                  return schemeManager.hasMoreData
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const SizedBox.shrink();
                }
                // Display each scheme item in the list
                return SchemeItem(scheme: schemes[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
