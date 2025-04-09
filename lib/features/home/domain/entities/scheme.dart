import 'package:equatable/equatable.dart';
class Scheme extends Equatable {
  final int? id;
  final String? schemeName;
  final String? category;
  final String? description;
  final String? launchDate;
  final String? expiryDate;
  final String? ageRange;
  final double? income;
  final String? occupation;
  final String? residenceType;
  final String? city;
  final String? gender;
  final String? caste;
  final String? benefitType;
  final bool? differentlyAbled;
  final String? maritalStatus;
  final double? disabilityPercentage;
  final bool? minority;
  final bool? bplCategory;
  final String? department;
  final String? applicationLink;
  final String? schemeDetails;
  final String? localBody;
  final String? educationCriteria;
  final List<String>? keywords;

  const Scheme({
    this.id,
    this.schemeName,
    this.category,
    this.description,
    this.launchDate,
    this.expiryDate,
    this.ageRange,
    this.income,
    this.occupation,
    this.residenceType,
    this.city,
    this.gender,
    this.caste,
    this.benefitType,
    this.differentlyAbled,
    this.maritalStatus,
    this.disabilityPercentage,
    this.minority,
    this.bplCategory,
    this.department,
    this.applicationLink,
    this.schemeDetails,
    this.localBody,
    this.educationCriteria,
    this.keywords,
  });
  @override
  List<Object?> get props => [
    id,
    schemeName,
    category,
    description,
    launchDate,
    expiryDate,
    ageRange,
    income,
    occupation,
    residenceType,
    city,
    gender,
    caste,
    benefitType,
    differentlyAbled,
    maritalStatus,
    disabilityPercentage,
    minority,
    bplCategory,
    department,
    applicationLink,
    schemeDetails,
    localBody,
    educationCriteria,
    keywords,
  ];
}