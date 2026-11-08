import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favourites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

/// FavouritesScreen with 3-Level Responsive Design.
/// 
/// Demonstrates:
/// - Responsive grid scaling (Mobile 2, Tablet 3-4, Desktop 5-6)
/// - Constrained layout for wide desktop displays
/// - Provider consumer for dynamic updates
class FavouritesScreen extends StatelessWidget {
  static const String routeName = '/favourites';

  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favourites = favouritesProvider.favourites;
    final screenWidth = MediaQuery.of(context).size.width;

    // 4-Level Responsive Breakpoints (Mobile, Tablet, Laptop, Desktop)
    final int crossAxisCount;
    final double horizontalPadding;
    final double maxContentWidth;

    if (screenWidth > 1440) {
      crossAxisCount = 6;
      horizontalPadding = 36.0;
      maxContentWidth = 1400.0;
    } else if (screenWidth > 1024) {
      crossAxisCount = screenWidth > 1200 ? 5 : 4;
      horizontalPadding = 28.0;
      maxContentWidth = 1240.0;
    } else if (screenWidth > 600) {
      crossAxisCount = screenWidth > 800 ? 4 : 3;
      horizontalPadding = 20.0;
      maxContentWidth = 960.0;
    } else {
      crossAxisCount = 2;
      horizontalPadding = 12.0;
      maxContentWidth = double.infinity;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Favourites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: favourites.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.getSecondaryBg(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: AppTheme.getSecondaryTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Favourites Yet',
                          style: TextStyle(
                            color: AppTheme.getTextColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore trending movies and tap the heart icon on any movie to save it here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.getSecondaryTextColor(context),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final movie = favourites[index];
                    return Stack(
                      children: [
                        MovieCard(
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
                                color: Colors.black.withValues(alpha: 0.75),
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
        ),
      ),
    );
  }
}
