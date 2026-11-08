import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/favourites_provider.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_poster.dart';

/// MovieDetailsScreen displays complete information about a selected movie.
/// 
/// Demonstrates:
/// - StatefulWidget
/// - Stack layout with dark gradient overlays
/// - Provider for favourite toggle
/// - Responsive scrolling with SingleChildScrollView
/// - Hero animation matching the source card poster
/// - Asynchronous enhancement of movie details (runtime & genres) from TMDB API
class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = '/movie-details';

  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Movie _movie;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
    _fetchExtraDetails();
  }

  void _fetchExtraDetails() async {
    final detailed = await MovieService().getMovieDetails(widget.movie.id);
    if (detailed != null && mounted) {
      setState(() {
        _movie = detailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final isFav = favouritesProvider.isFavourite(_movie);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Large Poster & Overlay Controls using Stack
            Stack(
              children: [
                // Backdrop / Poster Image with Hero
                Hero(
                  tag: 'movie-poster-${_movie.id}',
                  child: MoviePoster(
                    imageUrl: _movie.backdropUrl,
                    width: double.infinity,
                    height: size.height * 0.45,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                  ),
                ),

                // Cinematic Dark Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          AppTheme.background.withOpacity(0.8),
                          AppTheme.background,
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Navigation Bar (Back Button + Favourite Button)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Circular Back Button
                      CircleAvatar(
                        backgroundColor: AppTheme.cardColor.withOpacity(0.8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // Circular Favourite Button
                      CircleAvatar(
                        backgroundColor: AppTheme.cardColor.withOpacity(0.8),
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppTheme.primaryAccent : AppTheme.primaryText,
                          ),
                          onPressed: () {
                            favouritesProvider.toggleFavourite(_movie);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? 'Removed "${_movie.title}" from favourites'
                                      : 'Added "${_movie.title}" to favourites',
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppTheme.cardColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Movie Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _movie.title,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata Badges (Year, Runtime, Rating)
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _buildBadge(Icons.calendar_today, _movie.releaseYear),
                      _buildBadge(Icons.access_time, _movie.runtime),
                      _buildRatingBadge(_movie.voteAverage),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Genre Chips
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardColor),
                    ),
                    child: Text(
                      _movie.genre,
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Storyline Heading
                  const Text(
                    'Storyline',
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Overview / Description
                  Text(
                    _movie.overview,
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Action Toggle Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        favouritesProvider.toggleFavourite(_movie);
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: AppTheme.primaryText,
                      ),
                      label: Text(
                        isFav ? 'Remove from Favourites' : 'Add to Favourites',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFav ? AppTheme.cardColor : AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.secondaryText),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppTheme.starRatingColor),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
