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
    this.averagerating,
    this.totalrating,
    this.isBookmarked,
    this.userRating,
    this.process,
    this.documents
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
  final double? averagerating;
  final int? totalrating;
  final int? isBookmarked;
  final double? userRating;
  final String? process;
  final String? documents;

  factory SchemeModel.fromJson(Map<String, dynamic> map) {
    return SchemeModel(
      id: map['id'] as int?,
      schemeName: map['scheme_name']?.toString(),
      category: map['category']?.toString(),
      description: map['description']?.toString(),
      launchDate: map['launch_date']?.toString(),
      expiryDate: map['expiry_date']?.toString(),
      ageRange: map['age_range']?.toString(),
      income: (map['income'] is num) ? (map['income'] as num).toDouble() : null,
      occupation: map['occupation']?.toString(),
      residenceType: map['residence_type']?.toString(),
      city: map['city']?.toString(),
      gender: map['gender']?.toString(),
      caste: map['caste']?.toString(),
      benefitType: map['benefit_type']?.toString(),
      differentlyAbled: map['differently_abled'] as bool?,
      maritalStatus: map['marital_status']?.toString(),
      disabilityPercentage: (map['disability_percentage'] is num)
          ? (map['disability_percentage'] as num).toDouble()
          : null,
      minority: map['minority'] as bool?,
      bplCategory: map['bpl_category'] as bool?,
      department: map['department']?.toString(),
      applicationLink: map['application_link']?.toString(),
      schemeDetails: map['scheme_details']?.toString(), // important fix
      localBody: map['local_body']?.toString(),
      educationCriteria: map['education_criteria']?.toString(),
      keywords: (map['keywords'] is List)
          ? List<String>.from(map['keywords'].map((e) => e.toString()))
          : null,
      averagerating: map['average_rating'],
      totalrating: map['total_ratings'],
      isBookmarked: map['bookmark_id'],
      userRating: map['user_rating'],
      process: map['process'],
      documents: map['documents'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
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
      'marital_status': maritalStatus,
      'disability_percentage': disabilityPercentage,
      'department': department,
      'application_link': applicationLink,
      'scheme_details': schemeDetails,
      'local_body': localBody,
      'education_criteria': educationCriteria,
      'keywords': keywords,
      'average_rating': averagerating,
      'total_ratings': totalrating,
      'bookmark_id': isBookmarked,
      'user_rating': userRating,
      'process': process,
      'documents': documents,
    };

    if (differentlyAbled != null) map['differently_abled'] = differentlyAbled;
    if (minority != null) map['minority'] = minority;
    if (bplCategory != null) map['bpl_category'] = bplCategory;

    return map;
  }
}
