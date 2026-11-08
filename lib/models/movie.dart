/// Movie Model class representing a single movie in CINEMATE.
/// 
/// Demonstrates:
/// - Class definition and constructor
/// - Named parameters
/// - Null safety with default values
/// - JSON serialization (factory constructor)
/// - TMDB genre mapping
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

  /// Mapping of standard TMDB Genre IDs to names
  static const Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  /// Factory constructor to parse TMDB API response JSON into a Movie object.
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Extract year from "2024-03-01"
    String year = 'N/A';
    final releaseDate = json['release_date'] as String?;
    if (releaseDate != null && releaseDate.length >= 4) {
      year = releaseDate.substring(0, 4);
    }

    // Parse Genre
    String parsedGenre = 'Cinema';
    if (json['genres'] is List && (json['genres'] as List).isNotEmpty) {
      final names = (json['genres'] as List)
          .map((g) => g['name'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .take(2)
          .toList();
      if (names.isNotEmpty) {
        parsedGenre = names.join(' / ');
      }
    } else if (json['genre_ids'] is List && (json['genre_ids'] as List).isNotEmpty) {
      final ids = (json['genre_ids'] as List).cast<int>();
      final names = ids
          .map((id) => _genreMap[id])
          .where((name) => name != null)
          .take(2)
          .toList();
      if (names.isNotEmpty) {
        parsedGenre = names.join(' / ');
      }
    }

    // Parse Runtime
    String parsedRuntime = '120 min';
    if (json['runtime'] != null && json['runtime'] is num) {
      final int minutes = (json['runtime'] as num).toInt();
      if (minutes > 0) {
        parsedRuntime = '$minutes min';
      }
    }

    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      overview: (json['overview'] as String? ?? '').isNotEmpty
          ? json['overview'] as String
          : 'No description available for this title.',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      releaseYear: year,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genre: parsedGenre,
      runtime: parsedRuntime,
    );
  }

  /// Creates a copy of Movie with modified fields
  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseYear,
    double? voteAverage,
    String? genre,
    String? runtime,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseYear: releaseYear ?? this.releaseYear,
      voteAverage: voteAverage ?? this.voteAverage,
      genre: genre ?? this.genre,
      runtime: runtime ?? this.runtime,
    );
  }

  /// Returns the complete URL for the movie poster image.
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
