/// Movie Model class representing a single movie in CINEMATE.
/// 
/// Demonstrates:
/// - Class definition and constructor
/// - Named parameters
/// - Null safety with default values
/// - JSON serialization (factory constructor)
/// - Operator overloading (== and hashCode) for comparison
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseYear;
  final double voteAverage;
  final String genre;
  final String runtime;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath = '',
    required this.releaseYear,
    required this.voteAverage,
    this.genre = 'Drama / Sci-Fi',
    this.runtime = '120 min',
  });

  /// Factory constructor to parse TMDB API response JSON into a Movie object.
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Extract year from "2024-03-01" or fallback
    String year = 'N/A';
    final releaseDate = json['release_date'] as String?;
    if (releaseDate != null && releaseDate.length >= 4) {
      year = releaseDate.substring(0, 4);
    }

    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      overview: json['overview'] as String? ?? 'No description available.',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      releaseYear: year,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genre: 'Popular',
      runtime: '120 min',
    );
  }

  /// Returns the complete URL for the movie poster image.
  /// If it starts with 'http', returns as-is (useful for sample mock data).
  /// Otherwise, appends the TMDB image CDN prefix.
  String get posterUrl {
    if (posterPath.isEmpty) {
      return 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500&q=80';
    }
    if (posterPath.startsWith('http')) {
      return posterPath;
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  /// Returns the complete URL for the backdrop banner.
  String get backdropUrl {
    if (backdropPath.isEmpty) {
      return posterUrl;
    }
    if (backdropPath.startsWith('http')) {
      return backdropPath;
    }
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
