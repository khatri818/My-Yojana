import '../../domain/entities/scheme.dart';

class SchemeModel extends Scheme {
  const SchemeModel({
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

  factory SchemeModel.fromJson(Map<String, dynamic> map) {
    return SchemeModel(
      id: map['id'] as int?,
      schemeName: map['scheme_name'],
      category: map['category'],
      description: map['description'],
      launchDate: map['launch_date'],
      expiryDate: map['expiry_date'],
      ageRange: map['age_range'],
      income: (map['income'] as num?)?.toDouble(),
      occupation: map['occupation'],
      residenceType: map['residence_type'],
      city: map['city'],
      gender: map['gender'],
      caste: map['caste'],
      benefitType: map['benefit_type'],
      differentlyAbled: map['differently_abled'],
      maritalStatus: map['marital_status'],
      disabilityPercentage: (map['disability_percentage'] as num?)?.toDouble(),
      minority: map['minority'],
      bplCategory: map['bpl_category'],
      department: map['department'],
      applicationLink: map['application_link'],
      schemeDetails: map['scheme_details'],
      localBody: map['local_body'],
      educationCriteria: map['education_criteria'],
      keywords: (map['keywords'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheme_name': schemeName,
      'category': category,
      'description': description,
      'launch_date': launchDate,
      'expiry_date': expiryDate,
      'age_range': ageRange,
      'income': income,
      'occupation': occupation,
      'residence_type': residenceType,
      'city': city,
      'gender': gender,
      'caste': caste,
      'benefit_type': benefitType,
      'differently_abled': differentlyAbled,
      'marital_status': maritalStatus,
      'disability_percentage': disabilityPercentage,
      'minority': minority,
      'bpl_category': bplCategory,
      'department': department,
      'application_link': applicationLink,
      'scheme_details': schemeDetails,
      'local_body': localBody,
      'education_criteria': educationCriteria,
      'keywords': keywords,
    };
  }
}
