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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  String phoneNumber = '';
  String countryCode = '';
  String firebaseId = '';

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

  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedCasteCategory;
  String? _selectedEduCategory;
  bool? _selectedMinorityOption;
  bool? _selectedDisableOption;
  String? _selectedMaritalStatus;
  bool? _selectedBplOption;
  String? _selectedResidenceType;
  TextEditingController phoneController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  int _currentStep = 1;

  final List<String> _eligibilityOptions = ['Self', 'Spouse', 'Child', 'Parent'];
  final List<String> _schemeCategories = ['Education', 'Scholarship','Hospital', 'Agriculture','Insurance','Housing','Fund Support',];
  final List<String> _casteCategories = ['General', 'Other Backward Class (OBC)', 'Scheduled Caste','Scheduled Tribe'];
  final List<String> _eduCategories = ['Below 10th', 'Graduation', 'Above Graduation'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Yojana')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interested in checking which schemes you are eligible for?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const Text(
              'Please fill in the details below',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar and Back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: _currentStep > 1
                            ? () {
                          setState(() {
                            _currentStep--;
                          });
                        }
                            : null,
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            return Container(
                              width: 30,
                              height: 10,
                              decoration: BoxDecoration(
                                color: index < _currentStep ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Screen content
                  if (_currentStep == 1) ...[
                    _buildScreen1Content(),
                  ] else if (_currentStep == 2) ...[
                    _buildScreen2Content(),

                  ] else if (_currentStep == 3) ...[
                    _buildScreen3Content(),
                  ] else if (_currentStep == 4) ...[
                    _buildScreen4Content(),
                  ] else if (_currentStep == 5) ...[
                    _buildScreen5Content(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen1Content() {

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Enter Your Name'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
                      return 'Only alphabets allowed';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _lnameController,
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
                      return 'Only alphabets allowed';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Choose Your Gender'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOptionString('Male', _selectedGender, (value) {
                setState(() => _selectedGender = value);
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Female', _selectedGender, (value) {
                setState(() => _selectedGender = value);
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Other', _selectedGender, (value) {
                setState(() => _selectedGender = value);
              }),
            ],
          ),
          if (_selectedGender == null)
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 4),
              child: Text(
                'Please select a gender',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          const Text('Enter Your Age'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter your age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Age is required';
              }
              if (int.tryParse(value) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Enter Date of Birth'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _dobController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  hintText: 'Select your date of birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedGender != null) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields correctly'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOptionString(String optionValue, String? groupValue, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Radio<String>(
          value: optionValue,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(optionValue),
      ],
    );
  }


  Widget _buildScreen2Content() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Select Scheme Category'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            value: _selectedCategory,
            items: _schemeCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) => value == null ? 'Please select a category' : null,
          ),
          const SizedBox(height: 16),
          const Text('Enter Your Occupation'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _occupationController,
            decoration: InputDecoration(
              hintText: 'Enter your occupation',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Occupation cannot be empty' : null,
          ),
          const SizedBox(height: 16),
          const Text('Enter Your City'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'Enter your city',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'City cannot be empty' : null,
          ),
          const SizedBox(height: 16),
          const Text('Residence Type'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOptionString('Rural', _selectedResidenceType, (value) {
                setState(() {
                  _selectedResidenceType = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Urban', _selectedResidenceType, (value) {
                setState(() {
                  _selectedResidenceType = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Semi-Urban', _selectedResidenceType, (value) {
                setState(() {
                  _selectedResidenceType = value;
                });
              }),
            ],
          ),
          if (_selectedResidenceType == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Please select a residence type', style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _validateResidenceType()) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateResidenceType() {
    if (_selectedResidenceType == null) {
      setState(() {});
      return false;
    }
    return true;
  }

  Widget _buildRadioOption(bool optionValue, bool? groupValue, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Radio<bool>(
          value: optionValue,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(optionValue ? 'Yes' : 'No'),
      ],
    );
  }

  Widget _buildScreen3Content() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Select Category'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
            ),
            value: _selectedCasteCategory,
            items: _casteCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCasteCategory = value;
              });
            },
            validator: (value) =>
            value == null
                ? 'Please select a category'
                : null,
          ),
          const SizedBox(height: 16),
          const Text('Are you a minority?'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOption(true, _selectedMinorityOption, (value) {
                setState(() {
                  _selectedMinorityOption = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOption(false, _selectedMinorityOption, (value) {
                setState(() {
                  _selectedMinorityOption = value;
                });
              }),
            ],
          ),
          if (_selectedMinorityOption == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Please select an option',
                  style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          const Text('Are you Disabled?'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOption(true, _selectedDisableOption, (value) {
                setState(() {
                  _selectedDisableOption = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOption(false, _selectedDisableOption, (value) {
                setState(() {
                  _selectedDisableOption = value;
                });
              }),
            ],
          ),
          if (_selectedDisableOption == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Please select an option',
                  style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          const Text('Enter Your Disability Percentage'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _disabilityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter percentage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a percentage';
              }
              final percentage = int.tryParse(value);
              if (percentage == null || percentage < 0 || percentage > 100) {
                return 'Enter a valid percentage (0-100)';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen4Content() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Marital Status'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOptionString('Single', _selectedMaritalStatus, (value) {
                setState(() {
                  _selectedMaritalStatus = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Married', _selectedMaritalStatus, (value) {
                setState(() {
                  _selectedMaritalStatus = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOptionString('Divorced', _selectedMaritalStatus, (value) {
                setState(() {
                  _selectedMaritalStatus = value;
                });
              }),
            ],
          ),
          if (_selectedMaritalStatus == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Please select marital status', style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          const Text('Are you below poverty line?'),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOption(true, _selectedBplOption, (value) {
                setState(() {
                  _selectedBplOption = value;
                });
              }),
              const SizedBox(width: 8),
              _buildRadioOption(false, _selectedBplOption, (value) {
                setState(() {
                  _selectedBplOption = value;
                });
              }),
            ],
          ),
          if (_selectedBplOption == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Please select an option', style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          const Text('Enter Your Income'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter your income',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your income';
              }
              final income = double.tryParse(value);
              if (income == null || income < 0) {
                return 'Enter a valid income';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Select Education level'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            value: _selectedEduCategory,
            items: _eduCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedEduCategory = value;
              });
            },
            validator: (value) => value == null ? 'Please select education level' : null,
          ),
          const SizedBox(height: 24),
          Center(
            child: Consumer<AuthManager>(
              builder: (context, state, child) {
                if (state.registerLoadingStatus.loading) {
                  return const CircularProgressIndicator();
                }
                return Consumer<AuthManager>(
                  builder: (context, state, child) {
                    if (state.registerLoadingStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CommonButton(
                        label: "SUBMIT", onPressed: _onSubmitForm);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
  void _onSubmitForm() async {

    final manager = context.read<AuthManager>();

    String formatDate(String dobText) {
      try {
        // Try parsing the text into a DateTime object
        DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dobText);

        // Convert it to the desired format
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        return 'Error in Date'; // Return empty if parsing fails
      }
    }

    UserSignUpFormImplementation user = UserSignUpFormImplementation(
      firebaseId: firebaseId,
      name: '${_fnameController.text} ${_lnameController.text}',
      occupation: _occupationController.text,
      maritalStatus: _selectedMaritalStatus?.toLowerCase() ?? '',
      city: _cityController.text,
      residenceType: _selectedResidenceType?.toLowerCase() ?? '',
      category: _selectedCategory ?? '',
      differentlyAbled: _selectedDisableOption ?? false,
      disabilityPercentage: int.tryParse(_disabilityController.text) ?? 0,
      minority: _selectedMinorityOption ?? false,
      bplCategory: _selectedBplOption ?? false,
      income: double.tryParse(_incomeController.text) ?? 0.0,
      educationLevel: _selectedEduCategory ?? '',
      preferredLanguage: 'en',
      dob: formatDate(_dobController.text),
      gender: _selectedGender?.toLowerCase() ?? '',
    );




    await manager.signup(context, userSignUpFormData: user, onSuccess: () {
      // context.read<ProfileManager>().fetchProfile(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
            (Route<dynamic> route) => false,
      );
    });
  }

  Widget _buildScreen5Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              // // Add image
              // Image.asset(
              //   'assets/congrats.png', // Ensure this path matches your asset directory
              //   height: 160,
              //   width: 160,
              // ),
              const SizedBox(height: 12),
              // Add Congratulations text
              const Text(
                'Congratulations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Add eligibility message
              const Text(
                'You are eligible for 13 schemes',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              // Add Next button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Check Schemes'),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildGenderOption(String gender) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == gender ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == gender ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            gender,
            style: TextStyle(
              color: _selectedGender == gender ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildMaritalOption(String status) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = status;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == status ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == status ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: _selectedGender == status ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildResidenceOption(String residence) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = residence;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == residence ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == residence ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            residence,
            style: TextStyle(
              color: _selectedGender == residence ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDisableOption(String disable) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = disable;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == disable ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == disable ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            disable,
            style: TextStyle(
              color: _selectedGender == disable ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildMinorityOption(String minority) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = minority;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == minority ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == minority ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            minority,
            style: TextStyle(
              color: _selectedGender == minority ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBplOption(String bpl) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = bpl;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedGender == bpl ? Colors.blue : Colors.white,
            border: Border.all(
              color: _selectedGender == bpl ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            bpl,
            style: TextStyle(
              color: _selectedGender == bpl ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}