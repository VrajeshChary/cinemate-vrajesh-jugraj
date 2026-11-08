import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_poster.dart';
import '../widgets/section_title.dart';
import 'about_screen.dart';
import 'favourites_screen.dart';
import 'movie_details_screen.dart';
import 'search_screen.dart';

/// HomeScreen is the main entry screen of CINEMATE.
/// 
/// Demonstrates:
/// - StatefulWidget and lifecycle (initState)
/// - Asynchronous REST API fetching with async/await and try-catch
/// - CircularProgressIndicator for loading states
/// - Error handling with retry capability
/// - Featured movie banner with Stack and gradient overlay
/// - Horizontal scrolling with ListView.builder
/// - Vertical responsive grid with GridView.builder
/// - Navigation to Search, Favourites, About, and Details screens
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

  /// Fetches trending and popular movies from TMDB API / local sample service.
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
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// App bar featuring App name, icon, and quick action buttons.
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
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
      actions: [
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
            ),
            SizedBox(height: 16),
            Text(
              'Loading CINEMATE...',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
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
              const Icon(Icons.cloud_off, size: 64, color: AppTheme.secondaryText),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.secondaryText, fontSize: 16),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return RefreshIndicator(
      color: AppTheme.primaryAccent,
      backgroundColor: AppTheme.cardColor,
      onRefresh: _loadMovies,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar shortcut
            _buildSearchShortcut(),

            // 2. Featured Movie Banner
            if (_featuredMovie != null) _buildFeaturedSection(_featuredMovie!),

            // 3. Trending Movies Section (Horizontal ListView)
            const SectionTitle(title: 'Trending Movies'),
            SizedBox(
              height: 270,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: _trendingMovies.length,
                itemBuilder: (context, index) {
                  final movie = _trendingMovies[index];
                  return MovieCard(
                    movie: movie,
                    width: 145,
                    posterHeight: 200,
                    onTap: () => _openDetails(movie),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 4. Popular Movies Section (2-Column Grid)
            const SectionTitle(title: 'Popular Movies'),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: _popularMovies.length,
              itemBuilder: (context, index) {
                final movie = _popularMovies[index];
                return MovieCard(
                  movie: movie,
                  width: double.infinity,
                  posterHeight: 210,
                  onTap: () => _openDetails(movie),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Tappable search bar prompting users to open the search screen.
  Widget _buildSearchShortcut() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, SearchScreen.routeName),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.cardColor),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: AppTheme.secondaryText, size: 20),
              SizedBox(width: 12),
              Text(
                'Search movies by title...',
                style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Featured movie banner displayed prominently at the top.
  Widget _buildFeaturedSection(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => _openDetails(movie),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              MoviePoster(
                imageUrl: movie.backdropUrl,
                width: double.infinity,
                height: 220,
                borderRadius: 16,
                fit: BoxFit.cover,
              ),
              // Dark gradient overlay for readable text
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              // Featured text & action button
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED TODAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppTheme.starRatingColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          movie.releaseYear,
                          style: const TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                            ],
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

  void _openDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}
