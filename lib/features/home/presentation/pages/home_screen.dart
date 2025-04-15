import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_yojana/features/home/presentation/pages/search_screen.dart';
import 'package:my_yojana/features/home/presentation/manager/scheme_manger.dart';
import 'package:my_yojana/features/home/presentation/widgets/scheme_item.dart';
import 'package:my_yojana/features/home/presentation/widgets/scheme_card_style.dart';
import '../../../../core/enum/status.dart';
import '../widgets/filtered_scheme_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchemeManager>().getTopRatedScheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<SchemeManager>().getTopRatedScheme();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🌟 Top-Rated Schemes Carousel
                Consumer<SchemeManager>(
                  builder: (context, manager, _) {
                    final status = manager.topRatedSchemeStatus;
                    final topSchemes = manager.topRatedSchemes;

                    if (status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (topSchemes == null || topSchemes.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Rated Schemes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF444444),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 220,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            viewportFraction: 0.88,
                          ),
                          items: topSchemes
                              .map((scheme) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SchemeItem(scheme: scheme),
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 26),
                      ],
                    );
                  },
                ),

                /// 🔍 Search and Match Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SearchPage(isMatchScheme: false)),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 10),
                              Text(
                                'Search for schemes...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SearchPage(isMatchScheme: false)),
                          );
                        },
                        child: const Icon(
                          Icons.mic_none_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SearchPage(isMatchScheme: true)),
                          );
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.fact_check_outlined, color: Colors.deepOrange),
                            SizedBox(height: 2),
                            Text(
                              'Match',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                /// 💼 Business Schemes
                const Text(
                  'Schemes for your Business',
                  style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF444444),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSchemeGrid([
                  'Business',
                  'Loan',
                  'Financial Assistance',
                ]),

                const SizedBox(height: 26),

                /// 👨‍👩‍👧‍👦 Family Schemes
                const Text(
                  'Schemes for your Family',
                  style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF444444),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSchemeGrid([
                  'Health',
                  'Pension',
                  'Education',
                  'Housing',
                  'Insurance',
                  'Subsidy',
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeGrid(List<String> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStyledCard(category),
            const SizedBox(height: 6),
            Text(
              category,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStyledCard(String category) {
    final gradient = SchemeCardStyle.getGradient(category);
    final icon = SchemeCardStyle.getIcon(category);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FilteredSchemePage(category: category), // ✅ navigate to category-filtered page
          ),
        );
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
