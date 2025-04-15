import 'dart:async';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.language,
      'title': "NLP",
      'desc': "Natural Language Processing",
      'details': "Enables intuitive communication by interpreting user queries in natural language."
    },
    {
      'icon': Icons.search,
      'title': "Faceted Search",
      'desc': "Advanced Filters",
      'details': "Advanced filters for users to refine search results and find schemes effortlessly."
    },
    {
      'icon': Icons.recommend,
      'title': "Recommendations",
      'desc': "Tailored Suggestions",
      'details': "Tailors scheme suggestions based on user profiles, ensuring relevance and efficiency."
    },
    {
      'icon': Icons.accessibility,
      'title': "Accessibility",
      'desc': "Inclusive Design",
      'details': "Our app is designed for everyone, including users with disabilities, ensuring an inclusive experience."
    },
    {
      'icon': Icons.storage,
      'title': "Scalability",
      'desc': "Handles Large Data",
      'details': "Efficiently manages and processes large volumes of data to deliver seamless performance."
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final nextPage = (_currentPage + 1) % features.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AboutUs"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF2575FC)),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image and Title Section
              Image.asset('assets/images/bannerLogo.png'),
              const SizedBox(height: 32),

              // FAQ Section
              _buildWhatAppDoesCard(),

              const SizedBox(height: 40),

              // Features Section
              const Text(
                "Features",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFeatureCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatAppDoesCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue.shade50, // Light blue color for the container
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Align(
            alignment: Alignment.center, // Center align the content
            child: const Text(
              "What Does My Yojana Do?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          tilePadding: EdgeInsets.zero, // Remove extra padding
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "My Yojana simplifies access to government schemes, helping users identify eligibility with personalized recommendations. The purpose of My Yojana is to simplify access to government schemes by helping users identify which schemes they are eligible for based on their profile details, such as age, income, and occupation. By offering a user-friendly platform with personalized recommendations, voice search, and bookmarking, My Yojana ensures better reach and accessibility for all.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: features.length,
        itemBuilder: (context, index) {
          return _buildFeatureCard(features[index]);
        },
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(feature['icon'], color: Colors.blue, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        feature['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feature['details'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(feature['icon'], color: Colors.blue, size: 35),
              ),
              const SizedBox(height: 12),
              Text(
                feature['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feature['desc'],
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}