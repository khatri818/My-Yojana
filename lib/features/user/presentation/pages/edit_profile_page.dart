import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedEducation;
  String? _selectedResidenceType;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatus = ['Single', 'Married', 'Widowed'];
  final List<String> _educationLevels = ['Below 10th', 'Graduation', 'Post-Graduation'];
  final List<String> _residenceTypes = ['Rural', 'Urban', 'Semi-Urban'];

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle the save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully!")),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                value: _selectedGender,
                items: _genders.map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Marital Status'),
                value: _selectedMaritalStatus,
                items: _maritalStatus.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                onChanged: (value) => setState(() => _selectedMaritalStatus = value),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Education Level'),
                value: _selectedEducation,
                items: _educationLevels.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _selectedEducation = value),
              ),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(labelText: 'Occupation'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Residence Type'),
                value: _selectedResidenceType,
                items: _residenceTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _selectedResidenceType = value),
              ),
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Income'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2575FC),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
