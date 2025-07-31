class AppConstants {
  static const String appName = 'AyuboLife';
  static const String appTagline = 'Your Health Companion';
  
  // Google Fit constants
  static const String googleFitBaseUrl = 'https://www.googleapis.com/fitness/v1/users/me';
  static const List<String> googleFitScopes = [
    'https://www.googleapis.com/auth/fitness.activity.read',
    'https://www.googleapis.com/auth/fitness.body.read',
  ];
  
  // Default values
  static const int defaultCredits = 5000;
  static const int dailyStepsGoal = 10000;
  
  // Firebase collection names
  static const String usersCollection = 'users';
  static const String programsCollection = 'programs';
}