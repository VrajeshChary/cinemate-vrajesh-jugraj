import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_poster.dart';
import '../widgets/section_title.dart';
import 'about_screen.dart';
import 'favourites_screen.dart';
import 'movie_details_screen.dart';
import 'search_screen.dart';

/// HomeScreen with Multi-Device Responsive Design (Mobile, Tablet, Laptop, Desktop).
/// 
/// Demonstrates:
/// - Four-level responsive breakpoints:
///     * Mobile:  <= 600px (2 columns)
///     * Tablet:  601px - 1024px (3-4 columns)
///     * Laptop:  1025px - 1440px (4-5 columns, tailored 1240px container)
///     * Desktop: > 1440px (6 columns, widescreen 1440px container)
/// - Interactive Theme Toggle (Light & Dark) in top AppBar
/// - Asynchronous TMDB REST API fetching
/// - Stack layout with gradient overlays
/// - ListView.builder & GridView.builder
class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();

  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  Movie? _featuredMovie;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final trending = await _movieService.getTrendingMovies();
      final popular = await _movieService.getPopularMovies();

      setState(() {
        _trendingMovies = trending;
        _popularMovies = popular;
        if (trending.isNotEmpty) {
          _featuredMovie = trending.first;
        } else if (popular.isNotEmpty) {
          _featuredMovie = popular.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load movies. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isDesktop),
      body: _buildBody(screenWidth),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDesktop) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final themeToggleBtn = IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: isDark ? Colors.amber : AppTheme.getTextColor(context),
      ),
      onPressed: () => themeProvider.toggleTheme(),
    );

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.movie_creation, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text('CINEMATE'),
        ],
      ),
      actions: isDesktop
          ? [
              TextButton.icon(
                icon: Icon(Icons.search, color: AppTheme.getTextColor(context), size: 18),
                label: Text('Search', style: TextStyle(color: AppTheme.getTextColor(context))),
                onPressed: () => Navigator.pushNamed(context, SearchScreen.routeName),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: const Icon(Icons.favorite, color: AppTheme.primaryAccent, size: 18),
                label: Text('Favourites', style: TextStyle(color: AppTheme.getTextColor(context))),
                onPressed: () => Navigator.pushNamed(context, FavouritesScreen.routeName),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: Icon(Icons.info_outline, color: AppTheme.getTextColor(context), size: 18),
                label: Text('About', style: TextStyle(color: AppTheme.getTextColor(context))),
                onPressed: () => Navigator.pushNamed(context, AboutScreen.routeName),
              ),
              const SizedBox(width: 8),
              themeToggleBtn,
              const SizedBox(width: 16),
            ]
          : [
              themeToggleBtn,
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () => Navigator.pushNamed(context, SearchScreen.routeName),
              ),
              IconButton(
                tooltip: 'Favourites',
                icon: const Icon(Icons.favorite, color: AppTheme.primaryAccent),
                onPressed: () => Navigator.pushNamed(context, FavouritesScreen.routeName),
              ),
              IconButton(
                tooltip: 'About',
                icon: const Icon(Icons.info_outline),
                onPressed: () => Navigator.pushNamed(context, AboutScreen.routeName),
              ),
            ],
    );
  }

  Widget _buildBody(double screenWidth) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading CINEMATE...',
              style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64, color: AppTheme.getSecondaryTextColor(context)),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadMovies,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // 4-Level Responsive Layout Configuration (Mobile, Tablet, Laptop, Desktop)
    final int crossAxisCount;
    final double horizontalPadding;
    final double featuredHeight;
    final double trendingListHeight;
    final double cardWidth;
    final double cardPosterHeight;
    final double maxContentWidth;

    if (screenWidth > 1440) {
      // 1. Large Desktop / Monitor (> 1440px)
      crossAxisCount = 6;
      horizontalPadding = 36.0;
      featuredHeight = 380.0;
      trendingListHeight = 310.0;
      cardWidth = 180.0;
      cardPosterHeight = 240.0;
      maxContentWidth = 1400.0;
    } else if (screenWidth > 1024) {
      // 2. Laptop (1025px - 1440px: 1280x800, 1366x768, 1440x900)
      crossAxisCount = screenWidth > 1200 ? 5 : 4;
      horizontalPadding = 28.0;
      featuredHeight = 330.0;
      trendingListHeight = 290.0;
      cardWidth = 165.0;
      cardPosterHeight = 220.0;
      maxContentWidth = 1240.0;
    } else if (screenWidth > 600) {
      // 3. Tablet (601px - 1024px)
      crossAxisCount = screenWidth > 800 ? 4 : 3;
      horizontalPadding = 20.0;
      featuredHeight = 280.0;
      trendingListHeight = 275.0;
      cardWidth = 155.0;
      cardPosterHeight = 210.0;
      maxContentWidth = 960.0;
    } else {
      // 4. Mobile (<= 600px)
      crossAxisCount = 2;
      horizontalPadding = 12.0;
      featuredHeight = 220.0;
      trendingListHeight = 265.0;
      cardWidth = 145.0;
      cardPosterHeight = 195.0;
      maxContentWidth = double.infinity;
    }

    return RefreshIndicator(
      color: AppTheme.primaryAccent,
      backgroundColor: AppTheme.getCardColor(context),
      onRefresh: _loadMovies,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search Bar shortcut
                _buildSearchShortcut(horizontalPadding),

                // 2. Featured Movie Banner
                if (_featuredMovie != null)
                  _buildFeaturedSection(_featuredMovie!, featuredHeight, horizontalPadding),

                // 3. Trending Movies Section (Horizontal ListView)
                const SectionTitle(title: 'Trending Movies'),
                SizedBox(
                  height: trendingListHeight,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemCount: _trendingMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _trendingMovies[index];
                      return MovieCard(
                        movie: movie,
                        width: cardWidth,
                        posterHeight: cardPosterHeight,
                        onTap: () => _openDetails(movie),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // 4. Popular Movies Section (Responsive Grid)
                const SectionTitle(title: 'Popular Movies'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                    ),
                    itemCount: _popularMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _popularMovies[index];
                      return MovieCard(
                        movie: movie,
                        isGrid: true,
                        onTap: () => _openDetails(movie),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchShortcut(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, SearchScreen.routeName),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.getSecondaryBg(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.getBorder(context)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: AppTheme.getSecondaryTextColor(context), size: 20),
              const SizedBox(width: 12),
              Text(
                'Search movies by title...',
                style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(Movie movie, double height, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.0),
      child: GestureDetector(
        onTap: () => _openDetails(movie),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              MoviePoster(
                imageUrl: movie.backdropUrl,
                width: double.infinity,
                height: height,
                borderRadius: 16,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'FEATURED TODAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: AppTheme.primaryText,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.starRatingColor, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppTheme.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                movie.releaseYear,
                                style: const TextStyle(
                                  color: AppTheme.secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.cardColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  movie.genre,
                                  style: const TextStyle(
                                    color: AppTheme.secondaryText,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openDetails(movie),
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
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

  void _openDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}
