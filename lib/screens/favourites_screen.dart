import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favourites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

/// FavouritesScreen displays movies bookmarked by the user.
/// 
/// Demonstrates:
/// - StatelessWidget
/// - Consumer / Provider.of for listening to favourites state changes
/// - Responsive GridView.builder
/// - Empty state handling with intuitive icon and message
/// - Removing items from favourites
class FavouritesScreen extends StatelessWidget {
  static const String routeName = '/favourites';

  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favourites = favouritesProvider.favourites;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Favourites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: favourites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Favourites Yet',
                      style: TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore trending movies and tap the heart icon on any movie to save it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final movie = favourites[index];
                return Stack(
                  children: [
                    MovieCard(
                      movie: movie,
                      width: double.infinity,
                      posterHeight: 220,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                    ),
                    // Quick Remove Button
                    Positioned(
                      top: 6,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          favouritesProvider.removeFavourite(movie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed "${movie.title}"'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppTheme.cardColor,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
