import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:my_yojana/common/app_colors.dart';
import '../../../../core/enum/status.dart';
import '../../../user/presentation/manager/user_manager.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../manager/scheme_manger.dart';
import '../widgets/scheme_item.dart';

class SearchPage extends StatefulWidget {
  final bool isMatchScheme;

  const SearchPage({super.key, required this.isMatchScheme});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedEduCategory;
  bool _selectedMinorityOption = false;
  bool _selectedDisableOption = false;
  String? _selectedMaritalStatus;
  bool _selectedBplOption = false;
  String? _selectedResidenceType;

  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final List<String> _schemeCategories = [
    'Education', 'Scholarship', 'Hospital', 'Agriculture', 'Insurance', 'Housing', 'Fund support'
  ];
  final List<String> _eduCategories = ['Below 10th', 'Graduation', 'Above Graduation'];
  final List<String> _genders = ['male', 'female', 'other'];
  final List<String> _maritalStatus = ['single', 'married', 'widowed'];
  final List<String> _residenceTypes = ['rural', 'urban', 'semi-urban'];

  bool _isDataPrefilled = false;

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
    _scrollController.dispose();
    _searchController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _incomeController.dispose();
    _dobController.dispose();
    super.dispose();
  }

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
    _incomeController.text = user.income?.toString() ?? '';
    _dobController.text = user.dob ?? '';

    _isDataPrefilled = true;
    _onFilter();
  }

  void _onScroll() {
    final schemeManager = context.read<SchemeManager>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !schemeManager.schemePaginationLoadingStatus.loading &&
        schemeManager.hasMoreData) {
      schemeManager.getScheme(showLoading: false);
    }
  }

  void _onFilter() {
    final schemeManager = context.read<SchemeManager>();
    final double? income = double.tryParse(_incomeController.text.trim());
    schemeManager.setFilter(
      _selectedCategory,
      _selectedGender,
      _cityController.text.trim(),
      income,
      _selectedDisableOption,
      _selectedMinorityOption,
      _selectedBplOption,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedGender = null;
      _selectedCategory = null;
      _selectedEduCategory = null;
      _selectedMaritalStatus = null;
      _selectedResidenceType = null;
      _selectedMinorityOption = false;
      _selectedDisableOption = false;
      _selectedBplOption = false;
      _occupationController.clear();
      _cityController.clear();
      _incomeController.clear();
      _dobController.clear();
    });
    _onFilter();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() => _isListening = false);
          _speech.stop();
        }
      },
      onError: (error) => setState(() => _isListening = false),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() => _searchController.text = result.recognizedWords);
        _onSearch(result.recognizedWords);
      });
    }
  }

  void _onSearch(String query) {
    context.read<SchemeManager>().setSearchQuery(query);
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter Schemes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.clear_all, color: Colors.redAccent),
                        onPressed: _clearFilters,
                      )
                    ],
                  ),
                  const Divider(height: 24),
                  _buildDropdown("Gender", _selectedGender, _genders, (val) => setState(() => _selectedGender = val)),
                  const SizedBox(height: 12),
                  _buildDropdown("Scheme Category", _selectedCategory, _schemeCategories, (val) => setState(() => _selectedCategory = val)),
                  const SizedBox(height: 12),
                  _buildDropdown("Education Level", _selectedEduCategory, _eduCategories, (val) => setState(() => _selectedEduCategory = val)),
                  const SizedBox(height: 12),
                  _buildDropdown("Marital Status", _selectedMaritalStatus, _maritalStatus, (val) => setState(() => _selectedMaritalStatus = val)),
                  const SizedBox(height: 12),
                  _buildDropdown("Residence Type", _selectedResidenceType, _residenceTypes, (val) => setState(() => _selectedResidenceType = val)),
                  const SizedBox(height: 20),
                  _buildCheckbox("Are you from a minority group?", _selectedMinorityOption, (val) => setState(() => _selectedMinorityOption = val ?? false)),
                  _buildCheckbox("Are you differently abled?", _selectedDisableOption, (val) => setState(() => _selectedDisableOption = val ?? false)),
                  _buildCheckbox("Do you have a BPL card?", _selectedBplOption, (val) => setState(() => _selectedBplOption = val ?? false)),
                  const SizedBox(height: 12),
                  _buildTextField("Occupation", _occupationController),
                  _buildTextField("City", _cityController),
                  _buildTextField("Income", _incomeController, isNumber: true),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _onFilter();
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text("Apply Filters", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      value: value,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      controlAffinity: ListTileControlAffinity.leading,
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
        child: Column(
          children: [
            Container(
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
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'Enter Scheme Name to Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_isListening) {
                        _speech.stop();
                        setState(() => _isListening = false);
                      } else {
                        _startListening();
                      }
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: _isListening
                          ? Lottie.asset('assets/animations/mic_listening.json')
                          : const Icon(Icons.mic_none, color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: _showFilterOptions,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<SchemeManager>(
                  builder: (context, schemeManager, _) {
                    final schemes = schemeManager.scheme;
                    if (schemeManager.schemeLoadingStatus == Status.loading && (schemes == null || schemes.isEmpty)) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (schemes == null || schemes.isEmpty) {
                      return const Center(child: Text('Nothing to show here.'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        schemeManager.resetState();
                        await schemeManager.getScheme(showLoading: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: schemes.length + 1,
                        itemBuilder: (context, index) {
                          if (index == schemes.length) {
                            return schemeManager.hasMoreData
                                ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            )
                                : const SizedBox.shrink();
                          }
                          final scheme = schemes[index];
                          return SchemeItem(scheme: scheme);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
