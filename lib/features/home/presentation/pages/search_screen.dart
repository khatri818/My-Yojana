import 'package:flutter/material.dart';
import 'package:my_yojana/common/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedCasteCategory;
  String? _selectedEduCategory;
  bool _selectedMinorityOption = false;
  bool _selectedDisableOption = false;
  String? _selectedMaritalStatus;
  bool _selectedBplOption = false;
  String? _selectedResidenceType;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final List<String> _schemeCategories = [
    'Education',
    'Scholarship',
    'Hospital',
    'Agriculture',
    'Insurance',
    'Housing',
    'Fund Support',
  ];

  final List<String> _casteCategories = [
    'General',
    'Other Backward Class (OBC)',
    'Scheduled Caste',
    'Scheduled Tribe'
  ];

  final List<String> _eduCategories = [
    'Below 10th',
    'Graduation',
    'Above Graduation'
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatus = ['Single', 'Married', 'Widowed'];
  final List<String> _residenceTypes = ['Rural', 'Urban'];

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Gender'),
                      value: _selectedGender,
                      items: _genders
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedGender = val),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Scheme Category'),
                      value: _selectedCategory,
                      items: _schemeCategories
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedCategory = val),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Caste Category'),
                      value: _selectedCasteCategory,
                      items: _casteCategories
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedCasteCategory = val),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Education Level'),
                      value: _selectedEduCategory,
                      items: _eduCategories
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedEduCategory = val),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Marital Status'),
                      value: _selectedMaritalStatus,
                      items: _maritalStatus
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedMaritalStatus = val),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Residence Type'),
                      value: _selectedResidenceType,
                      items: _residenceTypes
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedResidenceType = val),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Are you from minority group?'),
                      value: _selectedMinorityOption,
                      onChanged: (val) => setModalState(() =>
                      _selectedMinorityOption = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Are you differently abled?'),
                      value: _selectedDisableOption,
                      onChanged: (val) => setModalState(() =>
                      _selectedDisableOption = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Do you have BPL card?'),
                      value: _selectedBplOption,
                      onChanged: (val) =>
                          setModalState(() => _selectedBplOption = val ?? false),
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _occupationController,
                      decoration: const InputDecoration(labelText: 'Occupation'),
                    ),
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    TextField(
                      controller: _disabilityController,
                      decoration: const InputDecoration(labelText: 'Disability %'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _incomeController,
                      decoration: const InputDecoration(labelText: 'Income'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _dobController,
                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setModalState(() {
                            _dobController.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Apply filters or search logic here
                      },
                      child: const Text("Apply Filters"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Schemes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.backgroundColor),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 10),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter scheme name to search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune_sharp, color: AppColors.backgroundColor),
                onPressed: () => _showFilterOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
