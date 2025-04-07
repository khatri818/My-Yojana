import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.firebaseUid,
    super.name,
    super.dob,
    super.gender,
    this.occupation,
    this.maritalStatus,
    this.city,
    this.residenceType,
    this.category,
    this.differentlyAbled,
    this.disabilityPercentage,
    this.minority,
    this.bplCategory,
    this.income,
    this.educationLevel,
    this.preferredLanguage = 'en',
  });

  final String? occupation;
  final String? maritalStatus;
  final String? city;
  final String? residenceType;
  final String? category;
  final bool? differentlyAbled;
  final double? disabilityPercentage;
  final bool? minority;
  final bool? bplCategory;
  final double? income;
  final String? educationLevel;
  final String preferredLanguage;

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'name': name,
      'dob': dob,
      'gender': gender, // Now directly a String
      'occupation': occupation,
      'maritalStatus': maritalStatus,
      'city': city,
      'residenceType': residenceType,
      'category': category,
      'differentlyAbled': differentlyAbled,
      'disabilityPercentage': disabilityPercentage,
      'minority': minority,
      'bplCategory': bplCategory,
      'income': income,
      'educationLevel': educationLevel,
      'preferredLanguage': preferredLanguage,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      firebaseUid: map['firebaseUid'] ?? '',
      name: map['name'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] as String?, // Directly using it as String
      occupation: map['occupation'],
      maritalStatus: map['marital_status'],
      city: map['city'],
      residenceType: map['residence_type'],
      category: map['category'],
      differentlyAbled: map['differently_abled'],
      disabilityPercentage: (map['disability_percentage'] as num?)?.toDouble(),
      minority: map['minority'],
      bplCategory: map['bpl_category'],
      income: (map['income'] as num?)?.toDouble(),
      educationLevel: map['education_level'],
      preferredLanguage: map['preferredLanguage'] ?? 'en',
    );
  }
}
