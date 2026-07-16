import '../../../../core/constants/job_categories.dart';

class JobFilterConfiguration {
  static const String title = 'Find Jobs';
  
  static const double minSalary = 5000;
  static const double maxSalary = 200000;

  static List<String> get categories => JobCategories.categoryList;

  static List<String> getJobRoles(String category) => JobCategories.getRolesForCategory(category);
  
  static List<String> getSpecializations(String role) => JobCategories.getSpecializationsForRole(role) ?? [];

  static const List<String> experienceLevels = [
    'Fresher',
    '1 Year',
    '2 Years',
    '3 Years',
    '5 Years',
    '10+ Years'
  ];

  static const List<String> distances = [
    '5 km',
    '10 km',
    '15 km',
    '25 km',
    '50 km',
    'Anywhere'
  ];

  static const List<String> employmentTypes = [
    'Full-Time',
    'Part-Time',
    'Contract',
    'Temporary',
    'Internship',
    'Remote',
    'Hybrid',
    'On-site'
  ];

  static const List<String> salaryTypes = [
    'Monthly',
    'Daily',
    'Hourly',
    'Annual'
  ];

  static const List<String> sortOptions = [
    'Recently Posted',
    'Highest Salary',
    'Nearest',
    'Most Relevant'
  ];
}
