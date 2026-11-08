import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

/// SearchScreen with 3-Level Responsive Design.
/// 
/// Demonstrates:
/// - Breakpoints: Mobile (2 cols), Tablet (3-4 cols), Desktop (5-6 cols)
/// - Constrained centered layout for wide screens
/// - Live TMDB search with loading, empty, and populated states
class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();

  List<Movie> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final results = await _movieService.searchMovies(trimmed);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 3-Level Responsive Breakpoints
    final int crossAxisCount;
    final double horizontalPadding;
    if (screenWidth > 1024) {
      crossAxisCount = screenWidth > 1400 ? 6 : 5;
      horizontalPadding = 32.0;
    } else if (screenWidth > 600) {
      crossAxisCount = screenWidth > 800 ? 4 : 3;
      horizontalPadding = 20.0;
    } else {
      crossAxisCount = 2;
      horizontalPadding = 12.0;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search Movies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Search Input Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: AppTheme.getTextColor(context)),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _performSearch,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      _performSearch('');
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by movie title (e.g. Inception, Batman)...',
                    prefixIcon: Icon(Icons.search, color: AppTheme.getSecondaryTextColor(context)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: AppTheme.getSecondaryTextColor(context)),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: _buildBody(crossAxisCount, horizontalPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(int crossAxisCount, double horizontalPadding) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppTheme.getBorder(context)),
            const SizedBox(height: 12),
            Text(
              'Search your favourite movies',
              style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter_outlined, size: 64, color: AppTheme.getSecondaryTextColor(context)),
            const SizedBox(height: 12),
            Text(
              'No movies found matching "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different keyword',
              style: TextStyle(color: AppTheme.getSecondaryTextColor(context), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.62,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return MovieCard(
          movie: movie,
          isGrid: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
        );
      },
    );
  }
}
