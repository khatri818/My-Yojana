import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/common_button.dart';
import '../../../../core/constant/storage_key.dart';
import '../../../../core/enum/status.dart';
import '../../../../core/model/form/user_sign_up_form.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/presentation/pages/bottom_navigation_page.dart';
import '../manager/auth_manger.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Separate GlobalKeys for multi-step form validations
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep4 = GlobalKey<FormState>();

  String phoneNumber = '';
  String countryCode = '';
  String firebaseId = '';
  int _currentStep = 1;

  TextEditingController phoneController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();

  // Selections
  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedCasteCategory;
  String? _selectedEduCategory;
  bool? _selectedMinorityOption;
  bool? _selectedDisableOption;
  String? _selectedMaritalStatus;
  bool? _selectedBplOption;
  String? _selectedResidenceType;

  final List<String> _schemeCategories = [
    'Health',
    'Insurance',
    'Employment',
    'Agriculture',
    'Housing',
    'Financial Assistance',
    'Safety',
    'Subsidy',
    'Education',
    'Pension',
    'Business',
    'Loan'
  ];
  final List<String> _casteCategories = [
    'General',
    'Other Backward Class (OBC)',
    'Scheduled Caste',
    'Scheduled Tribe'
  ];
  final List<String> _eduCategories = ['Below 10th', 'Graduation', 'Above Graduation'];

  @override
  void initState() {
    super.initState();
    _getPhoneNumberAndCountryCode();
    _init();
  }

  _init() {
    Future.delayed(Duration.zero, () {
      final manager = context.read<AuthManager>();
      manager.resetState();
    });
  }

  Future<void> _getPhoneNumberAndCountryCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseId = prefs.getString('token') ?? '';
    phoneNumber = prefs.getString('phoneNumber') ?? '';
    countryCode = prefs.getString('countryCode') ?? '';
    phoneController.text = '$countryCode $phoneNumber';
    setState(() {});
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onSubmitForm(AuthManager manager) async {
    String formatDate(String dobText) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(dobText);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (_) {
        return '';
      }
    }

    UserSignUpFormImplementation user = UserSignUpFormImplementation(
      firebaseId: firebaseId,
      name: '${_fnameController.text} ${_lnameController.text}',
      occupation: _occupationController.text,
      maritalStatus: _selectedMaritalStatus ?? '',
      city: _cityController.text,
      residenceType: _selectedResidenceType ?? '',
      category: _selectedCasteCategory ?? '',
      differentlyAbled: _selectedDisableOption ?? false,
      disabilityPercentage: int.tryParse(_disabilityController.text) ?? 0,
      minority: _selectedMinorityOption ?? false,
      bplCategory: _selectedBplOption ?? false,
      income: double.tryParse(_incomeController.text) ?? 0.0,
      educationLevel: _selectedEduCategory ?? '',
      preferredLanguage: 'en',
      dob: formatDate(_dobController.text),
      gender: _selectedGender ?? '',
    );

    await manager.signup(
      context,
      userSignUpFormData: user,
      onSuccess: () {
        setState(() {
          _currentStep++;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Register'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Fill in your details to get eligible schemes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _currentStep > 1
                            ? () => setState(() => _currentStep--)
                            : null,
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            5,
                                (index) => Container(
                              width: 30,
                              height: 10,
                              decoration: BoxDecoration(
                                color: index < _currentStep
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_currentStep == 1) _buildScreen1(),
                  if (_currentStep == 2) _buildScreen2(),
                  if (_currentStep == 3) _buildScreen3(),
                  if (_currentStep == 4) _buildScreen4(),
                  if (_currentStep == 5) _buildScreen5(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.blue]),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Step 1: Basic Details (Name, Gender, Age, DOB)
  Widget _buildScreen1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter your Name'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fnameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _lnameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Gender'),
          Row(
            children: ['male', 'female', 'other'].map((g) {
              return Expanded(
                child: RadioListTile<String>(
                  value: g,
                  title: Text(g),
                  groupValue: _selectedGender,
                  onChanged: (val) => setState(() => _selectedGender = val),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          /// Date of Birth picker
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _dobController.text = DateFormat('dd/MM/yyyy').format(date);
                final today = DateTime.now();
                final calculatedAge = today.year - date.year -
                    ((today.month < date.month ||
                        (today.month == date.month && today.day < date.day))
                        ? 1
                        : 0);
                _ageController.text = calculatedAge.toString();
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Age field
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Required';
              final age = int.tryParse(val);
              if (age == null) return 'Enter valid age';
              if (_dobController.text.isNotEmpty) {
                final dob = DateFormat('dd/MM/yyyy').parse(_dobController.text);
                final today = DateTime.now();
                final calculatedAge = today.year - dob.year -
                    ((today.month < dob.month ||
                        (today.month == dob.month &&
                            today.day < dob.day))
                        ? 1
                        : 0);
                if ((calculatedAge - age).abs() > 1) {
                  return 'Age does not match DOB';
                }
              }
              return null;
            },
            onTap: () async {
              // Also offer date picker via age field tap
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _dobController.text = DateFormat('dd/MM/yyyy').format(date);
                final today = DateTime.now();
                final calculatedAge = today.year - date.year -
                    ((today.month < date.month ||
                        (today.month == date.month && today.day < date.day))
                        ? 1
                        : 0);
                _ageController.text = calculatedAge.toString();
              }
            },
          ),



          const SizedBox(height: 24),
          _gradientButton('Next', () {
            if (_formKeyStep1.currentState!.validate()) {
              if (_selectedGender == null) {
                _showError('Please select your gender');
                return;
              }
              setState(() => _currentStep++);
            }
          }),
        ],
      ),
    );
  }


  // Step 2: Scheme and Residence Details
  Widget _buildScreen2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _occupationController,
            decoration: const InputDecoration(labelText: 'Occupation'),
            validator: (val) =>
            val == null || val.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'City'),
            validator: (val) =>
            val == null || val.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          const Text('Residence Type'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: ['rural', 'urban', 'semi-urban'].map((res) {
                return RadioListTile<String>(
                  value: res,
                  groupValue: _selectedResidenceType,
                  title: Text(res),
                  onChanged: (val) =>
                      setState(() => _selectedResidenceType = val),
                  dense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _gradientButton('Next', () {
            if (_formKeyStep2.currentState!.validate()) {
              if (_selectedResidenceType == null) {
                _showError('Please select your residence type');
                return;
              }
              setState(() => _currentStep++);
            }
          }),
        ],
      ),
    );
  }

  // Step 3: Caste and Disability Details
  Widget _buildScreen3() {
    return Form(
      key: _formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Caste Category'),
          DropdownButtonFormField<String>(
            value: _selectedCasteCategory,
            decoration: const InputDecoration(labelText: 'Caste'),
            items: _casteCategories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _selectedCasteCategory = val),
            validator: (val) =>
            val == null || val.trim().isEmpty ? 'Please select a caste' : null,
          ),
          const SizedBox(height: 16),
          const Text('Are you a Minority?'),
          Row(
            children: [true, false].map((val) {
              return Expanded(
                child: RadioListTile<bool>(
                  value: val,
                  groupValue: _selectedMinorityOption,
                  title: Text(val ? 'Yes' : 'No'),
                  onChanged: (v) => setState(() => _selectedMinorityOption = v),
                  dense: true,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Are you Disabled?'),
          Row(
            children: [true, false].map((val) {
              return Expanded(
                child: RadioListTile<bool>(
                  value: val,
                  groupValue: _selectedDisableOption,
                  title: Text(val ? 'Yes' : 'No'),
                  onChanged: (v) => setState(() => _selectedDisableOption = v),
                  dense: true,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _disabilityController,
            decoration: const InputDecoration(labelText: 'Disability %'),
            keyboardType: TextInputType.number,
            // Conditionally validate if the user is disabled.
            validator: (val) {
              if (_selectedDisableOption == true) {
                if (val == null || val.trim().isEmpty) {
                  return 'Required if disabled';
                }
                final percentage = int.tryParse(val);
                if (percentage == null || percentage < 0 || percentage > 100) {
                  return 'Enter a value between 0 and 100';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _gradientButton('Next', () {
            if (_formKeyStep3.currentState!.validate()) {
              if (_selectedMinorityOption == null) {
                _showError('Please select an option for Minority');
                return;
              }
              if (_selectedDisableOption == null) {
                _showError('Please select an option for Disability');
                return;
              }
              setState(() => _currentStep++);
            }
          }),
        ],
      ),
    );
  }

  // Step 4: Marital Status, BPL, Income, and Education
  Widget _buildScreen4() {
    return Form(
      key: _formKeyStep4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Marital Status'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: ['single', 'married', 'divorced'].map((m) {
                return RadioListTile<String>(
                  value: m,
                  title: Text(m),
                  groupValue: _selectedMaritalStatus,
                  onChanged: (v) => setState(() => _selectedMaritalStatus = v),
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Below Poverty Line?'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [true, false].map((val) {
                return RadioListTile<bool>(
                  value: val,
                  title: Text(val ? 'Yes' : 'No'),
                  groupValue: _selectedBplOption,
                  onChanged: (v) => setState(() => _selectedBplOption = v),
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _incomeController,
            decoration: const InputDecoration(labelText: 'Annual Income(₹)'),
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Required';
              if (double.tryParse(val) == null) return 'Enter a valid number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedEduCategory,
            decoration: const InputDecoration(labelText: 'Education'),
            items: _eduCategories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _selectedEduCategory = val),
            validator: (val) =>
            val == null || val.trim().isEmpty ? 'Please select education level' : null,
          ),
          const SizedBox(height: 24),
          Consumer<AuthManager>(
            builder: (context, authManager, _) {
              return _gradientButton('Submit', () {
                if (_formKeyStep4.currentState!.validate()) {
                  if (_selectedMaritalStatus == null) {
                    _showError('Please select your marital status');
                    return;
                  }
                  if (_selectedBplOption == null) {
                    _showError('Please select the BPL option');
                    return;
                  }
                  _onSubmitForm(authManager);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Step 5: Success Screen
  Widget _buildScreen5() {
    return Column(
      children: [
        const Icon(Icons.verified, color: Colors.green, size: 100),
        const SizedBox(height: 16),
        const Text('Congratulations!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('You are eligible for many schemes.'),
        const SizedBox(height: 24),
        _gradientButton('Check Schemes', () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNav()),
                (Route<dynamic> route) => false,
          );
        }),
      ],
    );
  }
}
