abstract class UserSignUpForm {
  final String? firebaseId;
  final String name;
  final String dob;
  final String gender;
  final String occupation;
  final String maritalStatus;
  final String city;
  final String residenceType;
  final String category;
  final bool differentlyAbled;
  final int disabilityPercentage;
  final bool minority;
  final bool bplCategory;
  final double income;
  final String educationLevel;
  final String preferredLanguage;

  UserSignUpForm({
    this.firebaseId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.occupation,
    required this.maritalStatus,
    required this.city,
    required this.residenceType,
    required this.category,
    required this.differentlyAbled,
    required this.disabilityPercentage,
    required this.minority,
    required this.bplCategory,
    required this.income,
    required this.educationLevel,
    this.preferredLanguage = 'en',
  });

  Map<String, dynamic> toMap();
}

class UserSignUpFormImplementation extends UserSignUpForm {
  UserSignUpFormImplementation({
    super.firebaseId,
    required super.name,
    required super.dob,
    required super.gender,
    required super.occupation,
    required super.maritalStatus,
    required super.city,
    required super.residenceType,
    required super.category,
    required super.differentlyAbled,
    required super.disabilityPercentage,
    required super.minority,
    required super.bplCategory,
    required super.income,
    required super.educationLevel,
    super.preferredLanguage = 'en',
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (firebaseId != null) 'firebase_id': firebaseId,
      'name': name,
      'dob': dob,
      'gender': gender,
      'occupation': occupation,
      'marital_status': maritalStatus,
      'city': city,
      'residence_type': residenceType,
      'category': category,
      'differently_abled': differentlyAbled,
      'disability_percentage': disabilityPercentage,
      'minority': minority,
      'bpl_category': bplCategory,
      'income': income,
      'education_level': educationLevel,
      'preferred_language': preferredLanguage,
    };
  }
}