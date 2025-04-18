import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_yojana/features/home/presentation/widgets/scheme_card_style.dart';
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
      schemeManager.clearFilters();
      schemeManager.setFilter(
        widget.category,
        '', '', 0.0,
        null, null, null,
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
      null, null, null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: SchemeCardStyle.getGradient(widget.category),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.category} Schemes',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
              padding: const EdgeInsets.only(top: 16),
              itemCount: schemes.length + 1,
              itemBuilder: (context, index) {
                if (index == schemes.length) {
                  return schemeManager.hasMoreData
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const SizedBox.shrink();
                }
                return SchemeItem(scheme: schemes[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
