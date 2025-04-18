import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/scheme.dart';
import '../manager/scheme_manger.dart';
import '../widgets/scheme_card_style.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart';

class SchemeDetailPage extends StatefulWidget {
  final int schemeId;
  final String firebaseId;
  final int userId;

  const SchemeDetailPage({super.key, required this.schemeId, required this.firebaseId, required this.userId});

  @override
  State<SchemeDetailPage> createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<SchemeDetailPage> with SingleTickerProviderStateMixin {
  Scheme? scheme;
  late TabController _tabController;
  double? _userRating;
  bool _isEditingRating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchSchemeDetails();
  }

  Future<void> _fetchSchemeDetails() async {
    final schemeManager = context.read<SchemeManager>();
    final result = await schemeManager.getSchemeId(widget.schemeId, widget.firebaseId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          scheme = result;
          _userRating = result?.userRating;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schemeManager = context.watch<SchemeManager>();
    final userManager = context.watch<UserManager>();

    if (scheme == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final DateFormat formatter = DateFormat.yMMMMd();
    final category = scheme!.category ?? "Uncategorized";
    final gradient = SchemeCardStyle.getGradient(category);
    final icon = SchemeCardStyle.getIcon(category);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text("Scheme Details"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          Consumer<SchemeManager>(
            builder: (context, schemeManager, _) {
              return IconButton(
                icon: Icon(
                  scheme!.isBookmarked != null ? Icons.bookmark : Icons.bookmark_outline,
                  color: Colors.white,
                ),
                onPressed: () async {
                  String? error;
                  final isBookmarking = scheme!.isBookmarked == null;

                  if (isBookmarking) {
                    error = await schemeManager.createBookmark(
                      firebaseId: widget.firebaseId,
                      schemeId: widget.schemeId,
                      userId: widget.userId,
                    );
                  } else {
                    error = await schemeManager.deleteBookmark(
                      userId: widget.userId,
                      firebaseId: widget.firebaseId,
                      bookmarkId: scheme!.isBookmarked!,
                    );
                  }

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            error != null ? Icons.error_outline : (isBookmarking ? Icons.bookmark_added : Icons.bookmark_remove),
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              error != null
                                  ? "Error: $error"
                                  : (isBookmarking ? "Scheme bookmarked" : "Bookmark removed"),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: error != null
                          ? Colors.redAccent
                          : (isBookmarking ? Colors.green.shade600 : Colors.orange.shade700),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      duration: const Duration(seconds: 3),
                      elevation: 6,
                    ),
                  );

                  if (error == null) {
                    await _fetchSchemeDetails();
                  }
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, gradient, icon),
                  _buildTabs(gradient),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildTabContent(formatter),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Color> gradient, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SchemeCardStyle.buildBackgroundIcon(category: scheme!.category ?? ''),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scheme!.schemeName ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              _buildRating(),
              const SizedBox(height: 12),
              Chip(
                avatar: Icon(icon, color: gradient.first, size: 18),
                label: Text(
                  scheme!.category ?? '',
                  style: TextStyle(color: gradient.first, fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              const SizedBox(height: 16),
              Text("Rate this scheme:", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: (scheme!.userRating == null || _isEditingRating)
                          ? () => setState(() => _userRating = starIndex.toDouble())
                          : null,
                      child: Icon(
                        _userRating != null && _userRating! >= starIndex
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amberAccent,
                        size: 28,
                      ),
                    );
                  }),
                  if (scheme!.userRating != null && !_isEditingRating)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      tooltip: "Edit Rating",
                      onPressed: () {
                        setState(() {
                          _isEditingRating = true;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildRatingButton(gradient),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return (scheme!.averagerating != null || scheme!.totalrating != null)
        ? Row(
      children: [
        if (scheme!.averagerating != null) ...[
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.amber, Colors.orangeAccent],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: const Icon(Icons.star_rounded, size: 20),
          ),
          const SizedBox(width: 6),
          Text(
            scheme!.averagerating!.toStringAsFixed(1),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
        if (scheme!.totalrating != null) ...[
          const SizedBox(width: 8),
          Text(
            "(${scheme!.totalrating!.toInt()} ratings)",
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ],
    )
        : const SizedBox.shrink();
  }

  Widget _buildRatingButton(List<Color> gradient) {
    final schemeManager = context.watch<SchemeManager>();
    final isSubmittingRating = schemeManager.schemeRatingStatus == Status.loading;

    final userManager = context.watch<UserManager>();
    final userId = userManager.user?.id ?? 0;

    final bool isAlreadyRated = scheme!.userRating != null && !_isEditingRating;

    return ElevatedButton(
      onPressed: (_userRating != null && !isAlreadyRated && !isSubmittingRating)
          ? () async {
        final error = await schemeManager.rateScheme(
          schemeId: widget.schemeId,
          userId: userId,
          rating: _userRating!,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  error != null ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    error != null ? "Error: $error" : "Rating submitted successfully!",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: error != null ? Colors.redAccent : Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            duration: const Duration(seconds: 3),
            elevation: 6,
          ),
        );

        if (error == null) {
          setState(() => _isEditingRating = false);
          await _fetchSchemeDetails();
        }
      }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isAlreadyRated ? Colors.grey.shade300 : Colors.white,
        foregroundColor: gradient.first,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: isSubmittingRating
          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(
        isAlreadyRated ? "Rating Submitted" : "Submit Rating",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTabs(List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: TabBar(
        controller: _tabController,
        labelColor: gradient.first,
        unselectedLabelColor: Colors.black45,
        indicatorColor: gradient.first,
        tabs: const [
          Tab(icon: Icon(Icons.description), text: "Detail"),
          Tab(icon: Icon(Icons.checklist), text: "Criteria"),
          Tab(icon: Icon(Icons.assignment_turned_in), text: "Process"),
          Tab(icon: Icon(Icons.folder_copy), text: "Docs"),
        ],
      ),
    );
  }

  Widget _buildTabContent(DateFormat formatter) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TabBarView(
        controller: _tabController,
        children: [
          _detailsTab(),
          _eligibilityTab(),
          _applyTab(),
          _docsTab(),
        ],
      ),
    );
  }

  Widget _detailsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scheme!.description ?? 'N/A', style: const TextStyle(fontSize: 14, color: Colors.black87), textAlign: TextAlign.justify),
          const SizedBox(height: 24),
          _buildInfoRow("Occupation", scheme!.occupation),
          _buildInfoRow("Benefit Type", scheme!.benefitType),
          _buildInfoRow("Department", scheme!.department),
          _buildInfoRow("City", scheme!.city),
          _buildInfoRow("Local Body", scheme!.localBody),
        ],
      ),
    );
  }

  Widget _eligibilityTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Age Range", scheme!.ageRange),
          _buildInfoRow("Income", scheme!.income?.toString()),
          _buildInfoRow("Education Criteria", scheme!.educationCriteria),
          _buildInfoRow("Residence Type", scheme!.residenceType),
          _buildInfoRow("Gender", scheme!.gender),
          _buildInfoRow("Caste", scheme!.caste),
          _buildInfoRow("Minority", scheme!.minority == true ? "Yes" : "No"),
          _buildInfoRow("Differently Abled", scheme!.differentlyAbled == true ? "Yes" : "No"),
          _buildInfoRow("Disability %", scheme!.disabilityPercentage?.toString()),
          _buildInfoRow("Marital Status", scheme!.maritalStatus),
          _buildInfoRow("BPL Category", scheme!.bplCategory == true ? "Yes" : "No"),
        ],
      ),
    );
  }

  Widget _applyTab() {
    final steps = scheme!.process?.split(';').where((s) => s.trim().isNotEmpty).toList();
    final link = scheme!.applicationLink;
    final uri = Uri.tryParse(link ?? '');
    final isWebLink = link != null && (link.startsWith('http://') || link.startsWith('https://'));

    Future<void> tryLaunchUrl() async {
      try {
        if (uri == null) throw 'Invalid URL format';
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
        } else {
          throw 'Cannot launch URL: $link';
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application Steps
          if (steps != null && steps.isNotEmpty) ...[
            const Text(
              "Application Process:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      step.trim(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // Application Link / Instructions
          if (link != null && link.isNotEmpty) ...[
            Text(
              link.startsWith('http://') || link.startsWith('https://')
                  ? "Application Link:"
                  : "How to Apply:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (link.startsWith('http://') || link.startsWith('https://'))
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: tryLaunchUrl,
                      child: Text(
                        link,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Link copied to clipboard")),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Colors.grey),
                    tooltip: "Copy link",
                  ),
                ],
              )
            else
              Text(
                link,
                style: const TextStyle(fontSize: 15),
              ),
          ]
        ],
      ),
    );
  }

  Widget _docsTab() {
    final docs = scheme!.documents?.split(';').where((d) => d.trim().isNotEmpty).toList();

    final launchDate = scheme!.launchDate != null
        ? DateFormat.yMMMMd().format(DateTime.parse(scheme!.launchDate!))
        : 'N/A';

    final expiryDate = scheme!.expiryDate != null
        ? DateFormat.yMMMMd().format(DateTime.parse(scheme!.expiryDate!))
        : 'N/A';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (docs != null && docs.isNotEmpty) ...[
            const Text(
              "Required Documents:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...docs.map((doc) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Text(
                      doc.trim(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // Dates Section
          const Text(
            "Scheme Duration:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 140, child: Text("Launch Date:", style: TextStyle(fontWeight: FontWeight.w600))),
              Text(launchDate),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 140, child: Text("Expiry Date:", style: TextStyle(fontWeight: FontWeight.w600))),
              Text(expiryDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          Expanded(
            child: Text(value ?? 'N/A', style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
