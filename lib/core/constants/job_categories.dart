class JobCategories {
  // Define categories and their roles
  static const Map<String, List<String>> categories = {
    'Teachers': [
      'Primary & Secondary School Teacher',
      'Physical Education Teacher',
      'English Teacher',
      'Foreign Language Teacher',
      'Mathematics Teacher',
      'Science Teacher',
      'Social Science Teacher',
      'Computer Teacher',
      'Arts & Crafts Teacher',
      'Handwriting Teacher',
      'Sports Teacher',
    ],
    'Priest': [
      'Temple Priest'
    ],
    'Sports Coach': [
      'Personal Sports Coach',
      'Academy Sports Coach'
    ],
    'Trainer': [
      'Fitness & Wellness Trainer',
      'Educational Trainer',
      'Arts & Creative Trainer',
      'Other Trainer'
    ],
    'Nurse': [
      'Nurse'
    ],
    'Warden': [
      'Warden'
    ]
  };

  // Define specializations for specific roles
  static const Map<String, List<String>> specializations = {
    'Primary & Secondary School Teacher': [
      'Telugu', 'Hindi', 'Tamil', 'Kannada', 'Malayalam', 'Sanskrit', 'Punjabi', 
      'Gujarati', 'Bengali', 'Urdu', 'Odia', 'Assamese', 'Konkani', 'Kashmiri', 
      'Nepali', 'Dogri', 'Bodo', 'Maithili', 'Manipuri', 'Santali', 'Sindhi', 'Others'
    ],
    'Foreign Language Teacher': [
      'French', 'German', 'Spanish', 'Japanese', 'Mandarin Chinese', 'Russian', 
      'Arabic', 'Korean', 'Persian', 'Portuguese', 'Others'
    ],
    'Science Teacher': [
      'General Science', 'Physics', 'Chemistry', 'Biology'
    ],
    'Social Science Teacher': [
      'History', 'Geography', 'Political Science', 'Economics', 'Others'
    ],
    'Arts & Crafts Teacher': [
      'Drawing', 'Painting', 'Craft Work', 'Classical Dance', 'Dance', 'Music', 'Others'
    ],
    'Sports Teacher': [
      'Cricket', 'Football', 'Kabaddi', 'Kho Kho', 'Volleyball', 'Basketball', 'Hockey', 
      'Badminton', 'Table Tennis', 'Tennis', 'Athletics', 'Swimming', 'Yoga', 'Chess', 
      'Martial Arts', 'Handball', 'Archery', 'Skating', 'Others'
    ],
    'Personal Sports Coach': [
      // Team Sports
      'Cricket Coach', 'Football Coach', 'Basketball Coach', 'Volleyball Coach', 
      'Hockey Coach', 'Handball Coach', 'Kabaddi Coach', 'Kho Kho Coach', 
      'Rugby Coach', 'Baseball Coach', 'Softball Coach', 'Netball Coach',
      // Athletics & Fitness
      'Athletics Coach', 'Cross Country Coach', 'Fitness Coach', 'Strength & Conditioning Coach',
      // Racquet Sports
      'Badminton Coach', 'Tennis Coach', 'Table Tennis Coach', 'Squash Coach', 'Pickleball Coach',
      // Aquatic Sports
      'Swimming Coach', 'Diving Coach', 'Water Polo Coach',
      // Combat Sports
      'Karate Coach', 'Taekwondo Coach', 'Judo Coach', 'Wrestling Coach', 'Boxing Coach', 
      'Kickboxing Coach', 'Wushu Coach',
      // Mind Sports
      'Chess Coach',
      // Precision Sports
      'Archery Coach', 'Shooting Coach',
      // Gymnastics
      'Gymnastics Coach', 'Rhythmic Gymnastics Coach', 'Aerobics Coach',
      // Skating & Cycling
      'Roller Skating Coach', 'Ice Skating Coach', 'Cycling Coach', 'BMX Coach',
      // Traditional Indian Sports
      'Mallakhamb Coach', 'Kushti Coach', 'Kalaripayattu Coach', 'Silambam Coach', 
      'Vallam Kali Coach', 'Jallikattu Coach',
      // Adventure Sports
      'Mountaineering Coach', 'Rock Climbing Coach', 'Trekking Instructor', 'Flyboarding Coach',
      // Other Sports
      'Golf Coach', 'Surfing Coach', 'Rowing Coach', 'Kayaking Coach', 'Sailing Coach', 
      'Triathlon Coach', 'Billiards Coach', 'Snooker Coach', 'Tug of War Coach', 'Others'
    ],
    'Academy Sports Coach': [
      // Same as Personal Sports Coach
      'Cricket Coach', 'Football Coach', 'Basketball Coach', 'Volleyball Coach', 
      'Hockey Coach', 'Handball Coach', 'Kabaddi Coach', 'Kho Kho Coach', 
      'Rugby Coach', 'Baseball Coach', 'Softball Coach', 'Netball Coach',
      'Athletics Coach', 'Cross Country Coach', 'Fitness Coach', 'Strength & Conditioning Coach',
      'Badminton Coach', 'Tennis Coach', 'Table Tennis Coach', 'Squash Coach', 'Pickleball Coach',
      'Swimming Coach', 'Diving Coach', 'Water Polo Coach',
      'Karate Coach', 'Taekwondo Coach', 'Judo Coach', 'Wrestling Coach', 'Boxing Coach', 
      'Kickboxing Coach', 'Wushu Coach',
      'Chess Coach',
      'Archery Coach', 'Shooting Coach',
      'Gymnastics Coach', 'Rhythmic Gymnastics Coach', 'Aerobics Coach',
      'Roller Skating Coach', 'Ice Skating Coach', 'Cycling Coach', 'BMX Coach',
      'Mallakhamb Coach', 'Kushti Coach', 'Kalaripayattu Coach', 'Silambam Coach', 
      'Vallam Kali Coach', 'Jallikattu Coach',
      'Mountaineering Coach', 'Rock Climbing Coach', 'Trekking Instructor', 'Flyboarding Coach',
      'Golf Coach', 'Surfing Coach', 'Rowing Coach', 'Kayaking Coach', 'Sailing Coach', 
      'Triathlon Coach', 'Billiards Coach', 'Snooker Coach', 'Tug of War Coach', 'Others'
    ],
    'Fitness & Wellness Trainer': [
      'Gym Trainer', 'Yoga Trainer', 'Zumba Trainer'
    ],
    'Educational Trainer': [
      'Abacus Trainer', 'Vedic Mathematics Trainer', 'Memory Techniques Trainer'
    ],
    'Arts & Creative Trainer': [
      'Dance Trainer', 'Classical Dance Trainer', 'Music Trainer', 'Craft Trainer', 
      'Drama Trainer', 'Photography Trainer'
    ],
    'Other Trainer': [
      'Fashion Designing Trainer', 'Beauty & Wellness Trainer', 'Computer Trainer', 'Others'
    ]
  };

  static List<String> get categoryList => categories.keys.toList();

  static List<String> getRolesForCategory(String category) {
    final list = categories[category]?.toList() ?? [];
    if (list.isNotEmpty && !list.contains('Others')) {
      list.add('Others');
    }
    return list;
  }

  static List<String>? getSpecializationsForRole(String role) {
    if (!specializations.containsKey(role)) return null;
    final list = specializations[role]!.toList();
    if (!list.contains('Others')) {
      list.add('Others');
    }
    return list;
  }
}
