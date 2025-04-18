import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../manager/user_manager.dart';
import '../../../../core/model/form/user_sign_up_form.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isEditing = false;
  bool loading = true;
  String? firebaseId;

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController maritalStatusController;
  late TextEditingController educationLevelController;
  late TextEditingController occupationController;
  late TextEditingController cityController;
  late TextEditingController residenceTypeController;
  late TextEditingController incomeController;
  late TextEditingController categoryController;

  int disabilityPercentage = 0;
  bool minority = false;
  bool differentlyAbled = false;
  bool bplCategory = false;

  final List<String> schemeCategories = [
    'Education', 'Scholarship', 'Hospital', 'Agriculture',
    'Insurance', 'Housing', 'Fund Support',
  ];

  final List<String> _casteCategories = [
    'General', 'Other Backward Class (OBC)', 'Scheduled Caste', 'Scheduled Tribe',
  ];

  final List<String> _eduCategories = [
    'Below 10th', 'Graduation', 'Above Graduation',
  ];

  final List<String> _genderOptions = ['male', 'female', 'other'];
  final List<String> _residenceTypes = ['Rural', 'Urban', 'Semi-Urban'];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final authManager = context.read<AuthManager>();
    final userManager = context.read<UserManager>();
    final userSession = await authManager.checkUser();
    if (!mounted) return;

    if (userSession == null || userSession.isNewUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    await userManager.getUser(userSession.token);
    final user = userManager.user;
    firebaseId = userSession.token;

    nameController = TextEditingController(text: user?.name ?? '');
    dobController = TextEditingController(text: user?.dob ?? '');
    genderController = TextEditingController(
      text: _genderOptions.firstWhere(
            (e) => e.toLowerCase() == (user?.gender ?? '').toLowerCase(),
        orElse: () => '',
      ),
    );
    categoryController = TextEditingController(
      text: _casteCategories.firstWhere(
            (e) => e.toLowerCase() == (user?.category ?? '').toLowerCase(),
        orElse: () => '',
      ),
    );
    maritalStatusController = TextEditingController(text: user?.maritalStatus ?? '');
    educationLevelController = TextEditingController(
      text: _eduCategories.firstWhere(
            (e) => e.toLowerCase() == (user?.educationLevel ?? '').toLowerCase(),
        orElse: () => '',
      ),
    );
    occupationController = TextEditingController(text: user?.occupation ?? '');
    categoryController = TextEditingController(text: user?.category ?? '');
    cityController = TextEditingController(text: user?.city ?? '');
    residenceTypeController = TextEditingController(
      text: _residenceTypes.firstWhere(
            (e) => e.toLowerCase() == (user?.residenceType ?? '').toLowerCase(),
        orElse: () => '',
      ),
    );
    incomeController = TextEditingController(text: user?.income?.toString() ?? '');

    disabilityPercentage = (user?.disabilityPercentage ?? 0).toInt();
    minority = user?.minority ?? false;
    differentlyAbled = user?.differentlyAbled ?? false;
    bplCategory = user?.bplCategory ?? false;

    setState(() => loading = false);
  }



  void _toggleEdit() => setState(() => isEditing = !isEditing);

  void _handleEditSave() {
    if (isEditing) {
      _saveChanges();
    } else {
      _toggleEdit();
    }
  }

  void _saveChanges() async {
    if (firebaseId == null) return;
    final manager = context.read<UserManager>();

    UserSignUpFormImplementation user = UserSignUpFormImplementation(
      firebaseId: firebaseId!,
      name: nameController.text,
      dob: dobController.text,
      gender: genderController.text,
      maritalStatus: maritalStatusController.text,
      educationLevel: educationLevelController.text,
      occupation: occupationController.text,
      city: cityController.text,
      residenceType: residenceTypeController.text,
      category: categoryController.text,
      income: double.tryParse(incomeController.text) ?? 0.0,
      disabilityPercentage: disabilityPercentage,
      minority: minority,
      differentlyAbled: differentlyAbled,
      bplCategory: bplCategory,
    );

    final result = await manager.updateUser(
      firebaseId: firebaseId!,
      userSignUpForm: user,
    );

    result.fold(
          (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Failed to update profile."),
            backgroundColor: Colors.red,
          ),
        );
      },
          (success) async {
        await manager.getUser(firebaseId!);
        setState(() => isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully."),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> options, IconData icon) {
    String? normalizedValue;
    for (var option in options) {
      if (option.toLowerCase() == controller.text.toLowerCase()) {
        normalizedValue = option;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 4),
                isEditing
                    ? DropdownButtonFormField<String>(
                  value: normalizedValue,
                  onChanged: (value) => setState(() => controller.text = value ?? ''),
                  items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
                )
                    : Text(controller.text.isNotEmpty ? controller.text : '-',
                    style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _buildDateField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 4),
                isEditing
                    ? GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today),
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                )
                    : Text(controller.text.isNotEmpty ? controller.text : '-',
                    style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }


Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                isEditing
                    ? TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    isDense: true,
                  ),
                )
                    : Text(controller.text.isNotEmpty ? controller.text : '-',
                    style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToggleSwitch(String label, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.toggle_on, color: Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: isEditing ? onChanged : null,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.percent, color: Color(0xFF2575FC), size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
            value: disabilityPercentage.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: isEditing
                ? (val) => setState(() => disabilityPercentage = val.toInt())
                : null,
          ),
          Text(
            '${disabilityPercentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E))),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    if (loading || firebaseId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Consumer<UserManager>(
        builder: (context, manager, _) {
          final user = manager.user;
          if (manager.userLoadingStatus.failure || user == null) {
            return const Center(child: Text("Something went wrong!"));
          }

          return SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile_background.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: topPadding + 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                child: Text(
                                  AppUtils.getInitials(user.name ?? ''),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3A5AFE),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildSection("Personal Information", [
                              _buildEditableField("Name", nameController, Icons.person),
                              _buildDateField("Date of Birth", dobController, Icons.cake),
                              _buildDropdownField("Gender", genderController, _genderOptions, Icons.wc),
                              _buildEditableField("Marital Status", maritalStatusController, Icons.favorite),
                              _buildDropdownField("Education Level", educationLevelController, _eduCategories, Icons.school),
                              _buildEditableField("Occupation", occupationController, Icons.work),
                            ]),
                            _buildSection("Location & Housing", [
                              _buildEditableField("City", cityController, Icons.location_city),
                              _buildDropdownField("Residence Type", residenceTypeController, _residenceTypes, Icons.home),
                            ]),
                            _buildSection("Financial & Social Info", [
                              _buildSlider("Disability Percentage"),
                              _buildToggleSwitch("Minority", minority, (v) => setState(() => minority = v)),
                              _buildToggleSwitch("Differently Abled", differentlyAbled, (v) => setState(() => differentlyAbled = v)),
                              _buildToggleSwitch("BPL Category", bplCategory, (v) => setState(() => bplCategory = v)),
                              _buildDropdownField("Caste Category", categoryController, _casteCategories, Icons.group),
                              _buildEditableField("Annual Income", incomeController, Icons.currency_rupee),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: topPadding + 10,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 255,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: _handleEditSave,
                    icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
                    label: Text(
                      isEditing ? "Save Changes" : "Edit Profile",
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2575FC),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
