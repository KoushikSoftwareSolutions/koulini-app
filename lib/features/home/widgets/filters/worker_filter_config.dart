import '../../../../core/constants/worker_categories.dart';

class WorkerFilterConfiguration {
  static const String title = 'Find Work';
  
  static const double minIncome = 5000;
  static const double maxIncome = 50000;

  static List<String> get categories => WorkerCategories.categoryList;

  static List<String> getOccupations(String category) => WorkerCategories.getOccupationsForCategory(category);


  static const List<String> experienceLevels = [
    'Fresher',
    '0-1 Year',
    '1-2 Years',
    '2-5 Years',
    '5-10 Years',
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

  static const List<String> workTypes = [
    'Daily Wage',
    'Weekly',
    'Monthly',
    'Contract',
    'Part-Time',
    'Full-Time',
    'Seasonal'
  ];

  static const List<String> availabilityOptions = [
    'Available Today',
    'Available Tomorrow',
    'Available This Week',
    'Any'
  ];

  static const List<String> sortOptions = [
    'Recently Posted',
    'Highest Pay',
    'Nearest',
    'Most Relevant'
  ];
}
