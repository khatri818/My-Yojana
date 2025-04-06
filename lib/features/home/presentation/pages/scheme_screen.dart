import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';

class SchemePage extends StatefulWidget {
  final String title;
  final String description;

  SchemePage({required this.title, required this.description});

  @override
  _SchemePageState createState() => _SchemePageState();
}

class _SchemePageState extends State<SchemePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isBookmarked = false; // Track bookmark state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Using dynamic title
        backgroundColor: AppColors.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border, // Toggle bookmark icon
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked; // Toggle state
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBookmarked ? 'Added to Bookmarks' : 'Removed from Bookmarks'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.backgroundColor),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description, // Using dynamic description
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Text("Popularity: "),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star_border, color: Colors.grey),
                        Icon(Icons.star_border, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(icon: Icon(Icons.description), text: "Details"),
                  Tab(icon: Icon(Icons.list), text: "Criteria"),
                  Tab(icon: Icon(Icons.downloading), text: "Process"),
                  Tab(icon: Icon(Icons.file_copy), text: "Documents"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Details about ${widget.title}: ${widget.description}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Center(child: Text("Criteria Information Coming Soon")),
                    const Center(child: Text("Process Information Coming Soon")),
                    const Center(child: Text("Documents Information Coming Soon")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
