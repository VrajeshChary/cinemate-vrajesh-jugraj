import 'package:flutter/foundation.dart';
import '../models/movie.dart';

/// FavouritesProvider manages the user's favourite movies list.
/// 
/// Demonstrates:
/// - Provider state management with ChangeNotifier
/// - Encapsulation (private list with unmodifiable getter)
/// - notifyListeners() to broadcast state changes across screens
class FavouritesProvider extends ChangeNotifier {
  final List<Movie> _favourites = [];

  List<Movie> get favourites => List.unmodifiable(_favourites);

  /// Checks whether a movie is already marked as favourite.
  bool isFavourite(Movie movie) {
    return _favourites.any((item) => item.id == movie.id);
  }

  /// Toggles a movie's favourite status.
  void toggleFavourite(Movie movie) {
    if (isFavourite(movie)) {
      _favourites.removeWhere((item) => item.id == movie.id);
    } else {
      _favourites.add(movie);
    }
    notifyListeners();
  }

  /// Explicitly removes a movie from favourites.
  void removeFavourite(Movie movie) {
    _favourites.removeWhere((item) => item.id == movie.id);
    notifyListeners();
  }
}
