import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_yojana/common/app_colors.dart';
import 'package:my_yojana/features/home/presentation/pages/scheme_screen.dart';
import 'package:my_yojana/features/home/presentation/pages/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> carouselItems = [
    {
      'title': 'Mahatma Jyotirao Phule Jan Arogya Yojana',
      'description': 'A health insurance scheme providing free medical treatment.'
    },
    {
      'title': 'Balasaheb Thackeray Krishi Sanjivani Yojana',
      'description': 'A financial assistance scheme for farmers.'
    },
    {
      'title': 'Maharashtra Unemployment Allowance Scheme',
      'description': 'Financial aid to educated unemployed youth.'
    }
  ];

  final List<Map<String, dynamic>> businessSchemes = [
    {'icon': Icons.article, 'label': 'REGISTRATION'},
    {'icon': Icons.monetization_on, 'label': 'FINANCIAL LINKAGES'},
    {'icon': Icons.business, 'label': 'MARKET LINKAGES'},
  ];

  final List<Map<String, dynamic>> familySchemes = [
    {'icon': Icons.list, 'label': 'ALL SCHEMES'},
    {'icon': Icons.insert_drive_file, 'label': 'DOCUMENTS'},
    {'icon': Icons.health_and_safety, 'label': 'HEALTH'},
    {'icon': Icons.savings, 'label': 'PENSION'},
    {'icon': Icons.school, 'label': 'EDUCATION'},
    {'icon': Icons.house, 'label': 'HOUSING'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: carouselItems.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchemePage(
                            title: item['title']!,
                            description: item['description']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.backgroundColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 3,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              item['title']!,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Flexible(
                            child: Text(
                              item['description']!,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SchemePage(
                                    title: item['title']!,
                                    description: item['description']!,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Know More',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.backgroundColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.backgroundColor),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchPage(isMatchScheme: false)),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Enter scheme name to search...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchPage(isMatchScheme: true),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: const Column(
                          children: [
                            Icon(Icons.fact_check_outlined, color: Colors.orange),
                            SizedBox(height: 2),
                            Text(
                              'Match Scheme',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text('Schemes for your Business', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: businessSchemes.length,
                itemBuilder: (context, index) {
                  return _schemeTile(businessSchemes[index]['icon'], businessSchemes[index]['label']);
                },
              ),
              const SizedBox(height: 10),
              const Text('Schemes for your Family', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 0),
                itemCount: familySchemes.length,
                itemBuilder: (context, index) {
                  return _schemeTile(familySchemes[index]['icon'], familySchemes[index]['label']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _schemeTile(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: AppColors.backgroundColor),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
