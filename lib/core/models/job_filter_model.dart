class JobFilterModel {
  double minSalary;
  double maxSalary;
  String? jobCategory;
  String? jobRole;
  String? customJobRole;
  String? specialization;
  String? customSpecialization;
  String? experience;
  Map<String, String>? location;
  String? distance;
  String? employmentType;
  String? salaryType;
  String sortBy;

  JobFilterModel({
    this.minSalary = 5000,
    this.maxSalary = 200000,
    this.jobCategory,
    this.jobRole,
    this.customJobRole,
    this.specialization,
    this.customSpecialization,
    this.experience,
    this.location,
    this.distance = 'Anywhere',
    this.employmentType,
    this.salaryType,
    this.sortBy = 'Recently Posted',
  });

  factory JobFilterModel.fromJson(Map<String, dynamic> json) {
    return JobFilterModel(
      minSalary: (json['minSalary'] as num?)?.toDouble() ?? 5000,
      maxSalary: (json['maxSalary'] as num?)?.toDouble() ?? 200000,
      jobCategory: json['jobCategory'] as String?,
      jobRole: json['jobRole'] as String?,
      customJobRole: json['customJobRole'] as String?,
      specialization: json['specialization'] as String?,
      customSpecialization: json['customSpecialization'] as String?,
      experience: json['experience'] as String?,
      location: json['location'] != null
          ? Map<String, String>.from(json['location'] as Map)
          : null,
      distance: json['distance'] as String? ?? 'Anywhere',
      employmentType: json['employmentType'] as String?,
      salaryType: json['salaryType'] as String?,
      sortBy: json['sortBy'] as String? ?? 'Recently Posted',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'jobCategory': jobCategory,
      'jobRole': jobRole,
      'customJobRole': customJobRole,
      'specialization': specialization,
      'customSpecialization': customSpecialization,
      'experience': experience,
      'location': location,
      'distance': distance,
      'employmentType': employmentType,
      'salaryType': salaryType,
      'sortBy': sortBy,
    };
  }
}
