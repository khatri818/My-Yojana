import 'package:flutter/material.dart';

class FilteredSchemePage extends StatelessWidget {
  final String category;
  const FilteredSchemePage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Schemes'),
      ),
      body: Center(
        child: Text('Display filtered schemes for $category here.'),
      ),
    );
  }
}
