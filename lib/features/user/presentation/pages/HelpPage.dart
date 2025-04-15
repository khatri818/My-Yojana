import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, String>> faqs = const [
    {
      'question': 'What is My Yojana?',
      'answer': 'My Yojana is a platform designed to simplify access to government schemes by providing personalized recommendations based on your profile.'
    },
    {
      'question': 'How do I use My Yojana?',
      'answer': 'Simply sign up, fill in your profile details like age, income, and occupation, and explore the recommended schemes tailored to your needs.'
    },
    {
      'question': 'Is My Yojana free to use?',
      'answer': 'Yes, My Yojana is completely free to use for all users.'
    },
    {
      'question': 'How can I find a specific scheme?',
      'answer': 'You can use the search bar or apply filters like age, location, and occupation to find specific schemes.'
    },
    {
      'question': 'What should I do if I encounter a problem?',
      'answer': 'If you encounter any issues, feel free to contact our support team using the “Contact Us” section in the app.'
    },
    {
      'question': 'Can I bookmark schemes for later?',
      'answer': 'Yes, you can bookmark schemes to save them for easy access later.'
    },
    {
      'question': 'How do I update my profile details?',
      'answer': 'You can update your profile details by navigating to the “Profile” section in the app and editing your information.'
    },
    {
      'question': 'Is my data secure on My Yojana?',
      'answer': 'Yes, we take data security seriously and implement strict measures to ensure your information remains private and secure.'
    },
  ];

  Map<int, bool> isExpanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              Image.asset('assets/images/bannerLogo.png'),
              const SizedBox(height: 16),


              // FAQ Section
              const Text(
                "FAQs",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  final isActive = isExpanded[index] ?? false;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ExpansionTile(
                        key: Key(index.toString()),
                        tilePadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            isExpanded[index] = expanded;
                          });
                        },
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            faq['question']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isActive ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              faq['answer']!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
