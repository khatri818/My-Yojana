// No changes to imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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

  bool _isMatchProfileEnabled = false;

  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final List<String> _schemeCategories = [
    'Health', 'Insurance', 'Employment', 'Agriculture',
    'Housing', 'Financial Assistance', 'Safety', 'Subsidy',
    'Education', 'Pension', 'Business', 'Loan'
  ];
  final List<String> _eduCategories = [
    'Below 10th',
    'Graduation',
    'Above Graduation'
  ];
  final List<String> _genders = ['male', 'female', 'other'];
  final List<String> _maritalStatus = ['single', 'married', 'widowed'];
  final List<String> _residenceTypes = ['Rural', 'Urban', 'Semi-urban'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final userManager = context.read<UserManager>();
    final schemeManager = context.read<SchemeManager>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isMatchScheme) {
        setState(() => _isMatchProfileEnabled = true);
        _prefillUserData(userManager);
        _onFilter();
      } else {
        _clearFilters();
        schemeManager.resetState();
        schemeManager.getScheme(showLoading: true);
      }
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
      _selectedCategory ?? '',
      _selectedGender ?? '',
      _cityController.text.trim(),
      income ?? 0.0,
      _selectedDisableOption,
      _selectedMinorityOption,
      _selectedBplOption,
    );
  }

  void _clearFilters() {
    final schemeManager = context.read<SchemeManager>();
    schemeManager.clearFilters();

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
      _isMatchProfileEnabled = false;
    });
  }

  void _prefillUserData(UserManager manager,
      [void Function(void Function())? setModalState]) {
    final user = manager.user;
    if (user == null) return;

    final setter = setModalState ?? setState;

    setter(() {
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
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() => _isListening = false);
          _speech.stop();
        }
      },
      onError: (_) => setState(() => _isListening = false),
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
    final userManager = context.read<UserManager>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28)),
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.9,
              builder: (context, scrollController) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    void turnOffMatchProfile() {
                      if (_isMatchProfileEnabled) {
                        setModalState(() => _isMatchProfileEnabled = false);
                        setState(() {});
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Filter Schemes",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800])),
                              TextButton.icon(
                                onPressed: () {
                                  _clearFilters();
                                  setModalState(() {});
                                  _onFilter();
                                },
                                icon: const Icon(
                                    Icons.clear_all, color: Colors.redAccent),
                                label: const Text("Clear Filters",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            activeColor: Colors.blueAccent,
                            title: const Text("Match My Profile"),
                            subtitle: const Text(
                                "Auto-fill filters using your saved profile"),
                            value: _isMatchProfileEnabled,
                            onChanged: (val) {
                              setModalState(() => _isMatchProfileEnabled = val);
                              setState(() {});
                              if (val) {
                                _prefillUserData(userManager, setModalState);
                                Future.delayed(
                                    const Duration(milliseconds: 200),
                                    _onFilter);
                              }
                            },
                          ),
                          const Divider(height: 28),
                          _buildDropdown(
                              "Gender", _selectedGender, _genders, (val) {
                            turnOffMatchProfile();
                            setModalState(() => _selectedGender = val);
                          }),
                          const SizedBox(height: 16),
                          _buildDropdown("Scheme Category", _selectedCategory,
                              _schemeCategories, (val) {
                                turnOffMatchProfile();
                                setModalState(() => _selectedCategory = val);
                              }),
                          const SizedBox(height: 16),
                          _buildDropdown(
                              "Education Level", _selectedEduCategory,
                              _eduCategories, (val) {
                            turnOffMatchProfile();
                            setModalState(() => _selectedEduCategory = val);
                          }),
                          const SizedBox(height: 16),
                          _buildDropdown(
                              "Marital Status", _selectedMaritalStatus,
                              _maritalStatus, (val) {
                            turnOffMatchProfile();
                            setModalState(() => _selectedMaritalStatus = val);
                          }),
                          const SizedBox(height: 16),
                          _buildDropdown(
                              "Residence Type", _selectedResidenceType,
                              _residenceTypes, (val) {
                            turnOffMatchProfile();
                            setModalState(() => _selectedResidenceType = val);
                          }),
                          const Divider(height: 28),
                          SwitchListTile.adaptive(
                            title: const Text("Are you from a minority group?"),
                            activeColor: Colors.blueAccent,
                            value: _selectedMinorityOption,
                            onChanged: (val) {
                              turnOffMatchProfile();
                              setModalState(() =>
                              _selectedMinorityOption = val);
                            },
                          ),
                          SwitchListTile.adaptive(
                            title: const Text("Are you differently abled?"),
                            activeColor: Colors.blueAccent,
                            value: _selectedDisableOption,
                            onChanged: (val) {
                              turnOffMatchProfile();
                              setModalState(() => _selectedDisableOption = val);
                            },
                          ),
                          SwitchListTile.adaptive(
                            title: const Text("Do you have a BPL card?"),
                            activeColor: Colors.blueAccent,
                            value: _selectedBplOption,
                            onChanged: (val) {
                              turnOffMatchProfile();
                              setModalState(() => _selectedBplOption = val);
                            },
                          ),
                          const Divider(height: 28),
                          _buildTextField("Occupation", _occupationController,
                              onChanged: (_) => turnOffMatchProfile()),
                          _buildTextField("City", _cityController,
                              onChanged: (_) => turnOffMatchProfile()),
                          _buildTextField(
                              "Income", _incomeController, isNumber: true,
                              onChanged: (_) => turnOffMatchProfile()),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _dobController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              prefixIcon: const Icon(
                                  Icons.calendar_today_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onTap: () async {
                              turnOffMatchProfile();
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().subtract(
                                    const Duration(days: 6570)),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  _dobController.text =
                                  "${picked.day}/${picked.month}/${picked
                                      .year}";
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.filter_alt_outlined),
                            label: const Text("Apply Filters",
                                style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _onFilter();
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
      ),
      value: value,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, void Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Schemes',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF004AAD),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: Consumer<SchemeManager>(
              builder: (context, schemeManager, _) {
                final schemes = schemeManager.scheme;
                if (schemeManager.schemeLoadingStatus == Status.loading &&
                    (schemes == null || schemes.isEmpty)) {
                  return const Center(child: CircularProgressIndicator());
                } else if (schemes == null || schemes.isEmpty) {
                  return Center(
                    child: Text(
                      'Nothing to show here.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    schemeManager.resetState();
                    await schemeManager.getScheme(showLoading: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: schemes.length + 1,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      if (index == schemes.length) {
                        return schemeManager.hasMoreData
                            ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        )
                            : const SizedBox.shrink();
                      }
                      return SchemeItem(scheme: schemes[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF004AAD)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for schemes...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
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
                icon: const Icon(
                    Icons.filter_alt_rounded, color: Color(0xFF004AAD)),
                onPressed: _showFilterOptions,
              )
            ],
          ),
        ),
      ),
    );
  }
}
