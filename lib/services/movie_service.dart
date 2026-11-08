import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

/// MovieService handles REST API calls to The Movie Database (TMDB).
/// 
/// If no API key is provided or if network requests fail, it gracefully
/// falls back to a built-in list of 10 high-quality sample movies so the
/// application works immediately without any setup required.
class MovieService {
  // Replace this with your personal TMDB API key if you have one.
  // Obtain one for free at: https://www.themoviedb.org/settings/api
  static const String apiKey = '';

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// Fetches trending movies for the current week.
  Future<List<Movie>> getTrendingMovies() async {
    if (apiKey.isEmpty || apiKey == 'YOUR_TMDB_API_KEY') {
      return getSampleTrendingMovies();
    }

    try {
      final url = Uri.parse('$_baseUrl/trending/movie/week?api_key=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List results = data['results'] as List;
        return results.map((item) => Movie.fromJson(item)).toList();
      } else {
        return getSampleTrendingMovies();
      }
    } catch (e) {
      // Graceful fallback on network timeout or offline
      return getSampleTrendingMovies();
    }
  }

  /// Fetches popular movies.
  Future<List<Movie>> getPopularMovies() async {
    if (apiKey.isEmpty || apiKey == 'YOUR_TMDB_API_KEY') {
      return getSamplePopularMovies();
    }

    try {
      final url = Uri.parse('$_baseUrl/movie/popular?api_key=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List results = data['results'] as List;
        return results.map((item) => Movie.fromJson(item)).toList();
      } else {
        return getSamplePopularMovies();
      }
    } catch (e) {
      return getSamplePopularMovies();
    }
  }

  /// Searches movies by title.
  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    if (apiKey.isEmpty || apiKey == 'YOUR_TMDB_API_KEY') {
      // Search in local sample collection
      final all = [...getSampleTrendingMovies(), ...getSamplePopularMovies()];
      final queryLower = query.toLowerCase();
      final seenIds = <int>{};
      final matches = <Movie>[];

      for (var movie in all) {
        if (!seenIds.contains(movie.id) &&
            movie.title.toLowerCase().contains(queryLower)) {
          seenIds.add(movie.id);
          matches.add(movie);
        }
      }
      return matches;
    }

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List results = data['results'] as List;
        return results.map((item) => Movie.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ===========================================================================
  // SAMPLE DATA (10 Curated Movies with HD Posters for Immediate Offline Use)
  // ===========================================================================

  static List<Movie> getSampleTrendingMovies() {
    return const [
      Movie(
        id: 101,
        title: 'Interstellar',
        overview:
            'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/xJHokMbljvjADYdit5fK5VQsXEG.jpg',
        releaseYear: '2014',
        voteAverage: 8.7,
        genre: 'Sci-Fi / Adventure',
        runtime: '169 min',
      ),
      Movie(
        id: 102,
        title: 'Inception',
        overview:
            'Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets, is offered a chance to regain his old life as payment for a task considered to be impossible: "inception".',
        posterPath:
            'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg',
        releaseYear: '2010',
        voteAverage: 8.8,
        genre: 'Action / Sci-Fi',
        runtime: '148 min',
      ),
      Movie(
        id: 103,
        title: 'Dune: Part Two',
        overview:
            'Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/xOMo8BRK7PfcJv9JCnx7s520042.jpg',
        releaseYear: '2024',
        voteAverage: 8.3,
        genre: 'Sci-Fi / Adventure',
        runtime: '166 min',
      ),
      Movie(
        id: 104,
        title: 'Oppenheimer',
        overview:
            'The story of J. Robert Oppenheimer’s role in the development of the atomic bomb during World War II and the complex political and moral aftermath.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg',
        releaseYear: '2023',
        voteAverage: 8.1,
        genre: 'Biography / Drama',
        runtime: '180 min',
      ),
      Movie(
        id: 105,
        title: 'Spider-Man: Across the Spider-Verse',
        overview:
            'Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg',
        releaseYear: '2023',
        voteAverage: 8.4,
        genre: 'Animation / Action',
        runtime: '140 min',
      ),
    ];
  }

  static List<Movie> getSamplePopularMovies() {
    return const [
      Movie(
        id: 106,
        title: 'The Dark Knight',
        overview:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg',
        releaseYear: '2008',
        voteAverage: 9.0,
        genre: 'Action / Crime',
        runtime: '152 min',
      ),
      Movie(
        id: 107,
        title: 'Pulp Fiction',
        overview:
            'A burger-loving hit man, his philosophical partner, a drug-addled gangster\'s moll and a washed-up boxer converge in four tales of violence and redemption.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg',
        releaseYear: '1994',
        voteAverage: 8.9,
        genre: 'Crime / Drama',
        runtime: '154 min',
      ),
      Movie(
        id: 108,
        title: 'Fight Club',
        overview:
            'An insomniac office worker looking for a way to change his life crosses paths with a devil-may-care soap maker and forms an underground fight club that evolves into something much more.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/hZkgoQYus5vegHoetLkCJzb17zJ.jpg',
        releaseYear: '1999',
        voteAverage: 8.4,
        genre: 'Drama',
        runtime: '139 min',
      ),
      Movie(
        id: 109,
        title: 'The Matrix',
        overview:
            'Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/7u3XmlizLY32shZniBtIZzgTeaq.jpg',
        releaseYear: '1999',
        voteAverage: 8.7,
        genre: 'Action / Sci-Fi',
        runtime: '136 min',
      ),
      Movie(
        id: 110,
        title: 'Avatar: The Way of Water',
        overview:
            'Set more than a decade after the events of the first film, learn the story of the Sully family, the trouble that follows them, the lengths they go to keep each other safe, and the tragedies they endure.',
        posterPath:
            'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
        backdropPath:
            'https://image.tmdb.org/t/p/w780/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
        releaseYear: '2022',
        voteAverage: 7.7,
        genre: 'Sci-Fi / Action',
        runtime: '192 min',
      ),
    ];
  }
}
