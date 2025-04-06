import 'package:equatable/equatable.dart';
class User extends Equatable {
  final String? firebaseUid;
  final String? name;
  final String? dob;
  final String? gender;
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

  const User({
    this.firebaseUid,
    this.name,
    this.dob,
    this.gender,
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

  @override
  List<Object?> get props => [
    firebaseUid,
    name,
    dob,
    gender,
    occupation,
    maritalStatus,
    city,
    residenceType,
    category,
    differentlyAbled,
    disabilityPercentage,
    minority,
    bplCategory,
    income,
    educationLevel,
    preferredLanguage,
  ];
}
