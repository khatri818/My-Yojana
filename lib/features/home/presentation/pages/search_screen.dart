import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_yojana/common/app_colors.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../manager/scheme_manger.dart';

class SearchPage extends StatefulWidget {
  final bool isMatchScheme;

  const SearchPage({super.key, required this.isMatchScheme});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchemeManager>().getScheme(showLoading: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final schemeManager = context.read<SchemeManager>();
      if (!schemeManager.schemePaginationLoadingStatus.loading &&
          schemeManager.hasMoreData) {
        schemeManager.getScheme(showLoading: false);
      }
    }
  }

  void _onSearch(String query) {
    final schemeManager = context.read<SchemeManager>();
    schemeManager.setSearchQuery(query);
  }

  // void _onFilter() {
  //   final schemeManager = context.read<SchemeManager>();
  //   schemeManager.setFilter();
  // }

  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedEduCategory;
  bool _selectedMinorityOption = false;
  bool _selectedDisableOption = false;
  String? _selectedMaritalStatus;
  bool _selectedBplOption = false;
  String? _selectedResidenceType;

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
    'Fund support',
  ];

  final List<String> _eduCategories = [
    'Below 10th',
    'Graduation',
    'Above Graduation'
  ];

  final List<String> _genders = ['male', 'female', 'other'];
  final List<String> _maritalStatus = ['single', 'married', 'widowed'];
  final List<String> _residenceTypes = ['rural', 'urban', 'semi-urban'];

  bool _isDataPrefilled = false;

  void _prefillUserData(UserManager manager) {
    if (_isDataPrefilled || manager.user == null) return;

    final user = manager.user!;
    _selectedGender = user.gender;
    _selectedCategory = user.category;
    _selectedEduCategory = user.educationLevel;
    _selectedMaritalStatus = user.maritalStatus;
    _selectedResidenceType = user.residenceType;

    _selectedMinorityOption = user.minority ?? false;
    _selectedDisableOption = user.differentlyAbled ?? false;
    _selectedBplOption = user.bplCategory ?? false;

    _occupationController.text = user.occupation ?? '';
    _cityController.text = user.city ?? '';
    _disabilityController.text = user.disabilityPercentage?.toString() ?? '';
    _incomeController.text = user.income?.toString() ?? '';
    _dobController.text = user.dob ?? '';

    _isDataPrefilled = true;
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Consumer<UserManager>(
          builder: (context, manager, _) {
            if (widget.isMatchScheme) {
              if (manager.userLoadingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (manager.userLoadingStatus == Status.failure || manager.user == null) {
                return const Center(child: Text('Failed to load user data.'));
              }

              if (!_isDataPrefilled) {
                _prefillUserData(manager);
              }
            }

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                // Apply filters or search logic here
                              },
                              icon: const Icon(Icons.filter_alt_outlined),
                              label: const Text("Apply Filters"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Gender'),
                                value: _selectedGender,
                                items: _genders
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setModalState(() => _selectedGender = val),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Scheme Category'),
                                value: _selectedCategory,
                                items: _schemeCategories
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setModalState(() => _selectedCategory = val),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Education Level'),
                                value: _selectedEduCategory,
                                items: _eduCategories
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setModalState(() => _selectedEduCategory = val),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Marital Status'),
                                value: _selectedMaritalStatus,
                                items: _maritalStatus
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setModalState(() => _selectedMaritalStatus = val),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Residence Type'),
                                value: _selectedResidenceType,
                                items: _residenceTypes
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setModalState(() => _selectedResidenceType = val),
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                title: const Text('Are you from minority group?'),
                                value: _selectedMinorityOption,
                                onChanged: (val) => setModalState(() => _selectedMinorityOption = val ?? false),
                              ),
                              CheckboxListTile(
                                title: const Text('Are you differently able?'),
                                value: _selectedDisableOption,
                                onChanged: (val) => setModalState(() => _selectedDisableOption = val ?? false),
                              ),
                              CheckboxListTile(
                                title: const Text('Do you have BPL card?'),
                                value: _selectedBplOption,
                                onChanged: (val) => setModalState(() => _selectedBplOption = val ?? false),
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
                                      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
      body: Consumer<UserManager>(
        builder: (context, manager, _) {
          if (widget.isMatchScheme &&
              manager.userLoadingStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
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
                  const SizedBox(width: 10),

                  // FIX: `Expanded` should not be inside a `const`
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Enter Scheme Name to Search...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                            _onSearch('');
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onChanged: _onSearch,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.tune_sharp,
                        color: AppColors.backgroundColor),
                    onPressed: () => _showFilterOptions(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
