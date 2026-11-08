import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

/// SearchScreen allows users to search movies by title in real-time.
/// 
/// Demonstrates:
/// - StatefulWidget
/// - setState for managing search state, query, and result lists
/// - TextEditingController
/// - GridView.builder with responsive column count
/// - Handling loading, empty, and result states
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

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive column count: 2 on mobile phones, 3+ on tablets/wider screens
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Search Movies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.primaryText),
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
              onChanged: (val) {
                if (val.isEmpty) {
                  _performSearch('');
                }
              },
              decoration: InputDecoration(
                hintText: 'Search by movie title (e.g. Interstellar)...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryText),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.secondaryText),
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
            child: _buildBody(crossAxisCount),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int crossAxisCount) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
        ),
      );
    }

    if (!_hasSearched) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppTheme.cardColor),
            SizedBox(height: 12),
            Text(
              'Search your favourite movies',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
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
            const Icon(Icons.movie_filter_outlined, size: 64, color: AppTheme.secondaryText),
            const SizedBox(height: 12),
            Text(
              'No movies found matching "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.secondaryText, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching with a different keyword',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return MovieCard(
          movie: movie,
          width: double.infinity,
          posterHeight: 220,
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
