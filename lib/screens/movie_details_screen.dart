import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/favourites_provider.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_poster.dart';

/// MovieDetailsScreen with 3-Level Responsive Design.
/// 
/// Demonstrates:
/// - Desktop theatrical side-by-side layout (> 1024px)
/// - Mobile / Tablet stacked backdrop banner layout (<= 1024px)
/// - Hero animation
/// - Provider integration for favourites
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final isFav = favouritesProvider.isFavourite(_movie);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isDesktop
          ? AppBar(
              title: Text(_movie.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppTheme.primaryAccent : AppTheme.getTextColor(context),
                  ),
                  onPressed: () => _toggleFav(favouritesProvider, isFav),
                ),
                const SizedBox(width: 16),
              ],
            )
          : null,
      body: isDesktop
          ? _buildDesktopLayout(favouritesProvider, isFav)
          : _buildMobileTabletLayout(context, favouritesProvider, isFav),
    );
  }

  /// Desktop Side-by-Side Theatrical Layout (> 1024px)
  Widget _buildDesktopLayout(FavouritesProvider favouritesProvider, bool isFav) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Large Movie Poster
              Hero(
                tag: 'movie-poster-${_movie.id}',
                child: MoviePoster(
                  imageUrl: _movie.posterUrl,
                  width: 340,
                  height: 480,
                  borderRadius: 16,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 48),

              // Right Column: Details & Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _movie.title,
                      style: TextStyle(
                        color: AppTheme.getTextColor(context),
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _buildBadge(Icons.calendar_today, _movie.releaseYear),
                        _buildBadge(Icons.access_time, _movie.runtime),
                        _buildRatingBadge(_movie.voteAverage),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.getSecondaryBg(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.getBorder(context)),
                          ),
                          child: Text(
                            _movie.genre,
                            style: TextStyle(
                              color: AppTheme.getSecondaryTextColor(context),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Storyline',
                      style: TextStyle(
                        color: AppTheme.getTextColor(context),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _movie.overview,
                      style: TextStyle(
                        color: AppTheme.getSecondaryTextColor(context),
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Actions Row
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _toggleFav(favouritesProvider, isFav),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          label: Text(isFav ? 'In Favourites' : 'Add to Favourites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav ? AppTheme.getCardColor(context) : AppTheme.primaryAccent,
                            foregroundColor: isFav ? AppTheme.getTextColor(context) : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back, color: AppTheme.getTextColor(context)),
                          label: Text('Back to Movies', style: TextStyle(color: AppTheme.getTextColor(context))),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.getBorder(context), width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mobile / Tablet Stacked Layout (<= 1024px)
  Widget _buildMobileTabletLayout(BuildContext context, FavouritesProvider favouritesProvider, bool isFav) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'movie-poster-${_movie.id}',
                child: MoviePoster(
                  imageUrl: _movie.backdropUrl,
                  width: double.infinity,
                  height: isTablet ? size.height * 0.5 : size.height * 0.45,
                  borderRadius: 0,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                        bgColor.withValues(alpha: 0.8),
                        bgColor,
                      ],
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.getCardColor(context).withValues(alpha: 0.85),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: AppTheme.getTextColor(context)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: AppTheme.getCardColor(context).withValues(alpha: 0.85),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppTheme.primaryAccent : AppTheme.getTextColor(context),
                        ),
                        onPressed: () => _toggleFav(favouritesProvider, isFav),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _movie.title,
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontSize: isTablet ? 30 : 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _buildBadge(Icons.calendar_today, _movie.releaseYear),
                    _buildBadge(Icons.access_time, _movie.runtime),
                    _buildRatingBadge(_movie.voteAverage),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.getSecondaryBg(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.getBorder(context)),
                      ),
                      child: Text(
                        _movie.genre,
                        style: TextStyle(
                          color: AppTheme.getSecondaryTextColor(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Storyline',
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _movie.overview,
                  style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleFav(favouritesProvider, isFav),
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(isFav ? 'Remove from Favourites' : 'Add to Favourites'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFav ? AppTheme.getCardColor(context) : AppTheme.primaryAccent,
                      foregroundColor: isFav ? AppTheme.getTextColor(context) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFav(FavouritesProvider provider, bool isFav) {
    provider.toggleFavourite(_movie);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav
              ? 'Removed "${_movie.title}" from favourites'
              : 'Added "${_movie.title}" to favourites',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.getCardColor(context),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.getSecondaryTextColor(context)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.getTextColor(context),
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
        color: AppTheme.getCardColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppTheme.starRatingColor),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: AppTheme.getTextColor(context),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
