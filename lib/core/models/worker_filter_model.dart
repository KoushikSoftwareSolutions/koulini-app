class WorkerFilterModel {
  double minIncome;
  double maxIncome;
  String? category;
  String? occupation;
  String? customOccupation;
  String? experience;
  Map<String, String>? location;
  String? distance;
  String? workType;
  String? availability;
  String sortBy;

  WorkerFilterModel({
    this.minIncome = 5000,
    this.maxIncome = 50000,
    this.category,
    this.occupation,
    this.customOccupation,
    this.experience,
    this.location,
    this.distance = 'Anywhere',
    this.workType,
    this.availability,
    this.sortBy = 'Recently Posted',
  });

  factory WorkerFilterModel.fromJson(Map<String, dynamic> json) {
    return WorkerFilterModel(
      minIncome: (json['minIncome'] as num?)?.toDouble() ?? 5000,
      maxIncome: (json['maxIncome'] as num?)?.toDouble() ?? 50000,
      category: json['category'] as String?,
      occupation: json['occupation'] as String?,
      customOccupation: json['customOccupation'] as String?,
      experience: json['experience'] as String?,
      location: json['location'] != null
          ? Map<String, String>.from(json['location'] as Map)
          : null,
      distance: json['distance'] as String? ?? 'Anywhere',
      workType: json['workType'] as String?,
      availability: json['availability'] as String?,
      sortBy: json['sortBy'] as String? ?? 'Recently Posted',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minIncome': minIncome,
      'maxIncome': maxIncome,
      'category': category,
      'occupation': occupation,
      'customOccupation': customOccupation,
      'experience': experience,
      'location': location,
      'distance': distance,
      'workType': workType,
      'availability': availability,
      'sortBy': sortBy,
    };
  }
}
