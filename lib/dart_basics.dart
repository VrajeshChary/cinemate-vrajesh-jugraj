/// ============================================================================
/// DART BASICS DEMONSTRATION FILE - CINEMATE
/// ============================================================================
/// This file provides beginner-friendly, executable examples of fundamental Dart
/// concepts commonly examined in college viva / practical assessments.
/// ============================================================================

void main() {
  print('--- 1. Variables and Data Types ---');
  // String, int, double, bool
  String appName = 'CINEMATE';
  int releaseYear = 2024;
  double appVersion = 1.0;
  bool isDarkThemeEnabled = true;

  print('App: $appName, Year: $releaseYear, Version: $appVersion, Dark Mode: $isDarkThemeEnabled');

  print('\n--- 2. Lists and Maps ---');
  // List (ordered collection)
  List<String> genres = ['Action', 'Sci-Fi', 'Drama', 'Comedy'];
  genres.add('Thriller');
  print('Movie Genres: $genres');

  // Map (key-value pairs)
  Map<String, dynamic> movieRatingMap = {
    'Interstellar': 8.7,
    'Inception': 8.8,
    'The Dark Knight': 9.0,
  };
  print('Top Rated Movies: $movieRatingMap');

  print('\n--- 3. Functions ---');
  double avg = calculateAverageRating([8.7, 8.8, 9.0]);
  print('Average Rating: ${avg.toStringAsFixed(2)}');

  print('\n--- 4. If-Else Conditions ---');
  checkMovieRecommendation(8.8);

  print('\n--- 5. Loops (for, for-in, while) ---');
  // For loop
  for (int i = 0; i < genres.length; i++) {
    print('Genre #${i + 1}: ${genres[i]}');
  }

  // While loop
  int countdown = 3;
  while (countdown > 0) {
    print('Movie starts in $countdown...');
    countdown--;
  }

  print('\n--- 6. Classes and Objects ---');
  SimpleMovie sample = SimpleMovie('Inception', 2010, 8.8);
  sample.printSummary();

  print('\n--- 7. Null Safety (? and ??) ---');
  String? optionalSubtitle; // Nullable String
  print('Subtitle: ${optionalSubtitle ?? "No subtitle provided"}'); // Fallback operator
}

/// Function with typed parameter and return value
double calculateAverageRating(List<double> ratings) {
  if (ratings.isEmpty) return 0.0;
  double sum = 0.0;
  for (double rating in ratings) {
    sum += rating;
  }
  return sum / ratings.length;
}

/// If-Else condition demonstration
void checkMovieRecommendation(double rating) {
  if (rating >= 8.5) {
    print('Verdict: Highly Recommended Blockbuster!');
  } else if (rating >= 7.0) {
    print('Verdict: Good Watch.');
  } else {
    print('Verdict: Average.');
  }
}

/// Simple Class and Object demonstration
class SimpleMovie {
  final String title;
  final int year;
  final double rating;

  // Constructor
  SimpleMovie(this.title, this.year, this.rating);

  void printSummary() {
    print('Movie: $title ($year) - Rating: $rating/10');
  }
}
