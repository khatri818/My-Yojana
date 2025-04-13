import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/scheme.dart';
import '../manager/scheme_manger.dart';
import '../widgets/scheme_card_style.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart'; // ✅ Import UserManager

class SchemeDetailPage extends StatefulWidget {
  final int schemeId;

  const SchemeDetailPage({super.key, required this.schemeId});

  @override
  State<SchemeDetailPage> createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<SchemeDetailPage> with SingleTickerProviderStateMixin {
  Scheme? scheme;
  late TabController _tabController;
  bool isBookmarked = false;
  double? _userRating;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchSchemeDetails();
  }

  Future<void> _fetchSchemeDetails() async {
    final schemeManager = context.read<SchemeManager>();
    final result = await schemeManager.getSchemeId(widget.schemeId);
    setState(() {
      scheme = result;
      _userRating = result?.userRating;
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
    final isSubmittingRating = schemeManager.schemeRatingStatus == Status.loading;

    final userManager = context.watch<UserManager>();
    final userId = userManager.user?.id ?? 0;

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
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => isBookmarked = !isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBookmarked ? 'Bookmarked' : 'Removed from Bookmarks'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          )
        ],
      ),
      body: Align(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SchemeCardStyle.buildBackgroundIcon(category: category),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme!.schemeName ?? '',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          if (scheme!.averagerating != null || scheme!.totalrating != null)
                            Row(
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
                            ),
                          const SizedBox(height: 12),
                          Chip(
                            avatar: Icon(icon, color: gradient.first, size: 18),
                            label: Text(
                              category,
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
                            children: List.generate(5, (index) {
                              final starIndex = index + 1;
                              return GestureDetector(
                                onTap: scheme!.userRating == null
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
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: (_userRating != null &&
                                scheme!.userRating == null &&
                                !isSubmittingRating)
                                ? () async {
                              final error = await schemeManager.rateScheme(
                                schemeId: widget.schemeId,
                                userId: userId,
                                rating: _userRating!,
                              );
                              if (error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $error")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Rating submitted successfully!")),
                                );
                                await _fetchSchemeDetails();
                              }
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme!.userRating != null ? Colors.grey.shade300 : Colors.white,
                              foregroundColor: gradient.first,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: isSubmittingRating
                                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : Text(scheme!.userRating != null ? "Rating Submitted" : "Submit Rating"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: gradient.first,
                    unselectedLabelColor: Colors.black45,
                    indicatorColor: gradient.first,
                    tabs: const [
                      Tab(icon: Icon(Icons.description_outlined), text: "Details"),
                      Tab(icon: Icon(Icons.check_circle_outline), text: "Criteria"),
                      Tab(icon: Icon(Icons.how_to_reg), text: "Apply"),
                      Tab(icon: Icon(Icons.event), text: "Dates"),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _detailsTab(),
                        _eligibilityTab(),
                        _applyTab(),
                        _datesTab(
                          scheme!.launchDate != null
                              ? formatter.format(DateTime.parse(scheme!.launchDate!))
                              : 'N/A',
                          scheme!.expiryDate != null
                              ? formatter.format(DateTime.parse(scheme!.expiryDate!))
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            scheme!.description ?? 'N/A',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
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
    final link = scheme!.applicationLink;
    final isWebLink = link != null && (link.startsWith('http://') || link.startsWith('https://'));
    final uri = Uri.tryParse(link ?? '');

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
      child: link == null || link.isEmpty
          ? const Text("Application link not available.")
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Application Link:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          isWebLink
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: tryLaunchUrl,
                child: Text(
                  link,
                  style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: tryLaunchUrl,
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text("Apply"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          )
              : Text(link, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _datesTab(String launch, String expiry) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Launch Date", launch),
          _buildInfoRow("Expiry Date", expiry),
          const SizedBox(height: 10),

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
