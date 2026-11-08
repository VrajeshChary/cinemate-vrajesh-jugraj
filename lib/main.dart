import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/movie.dart';
import 'screens/about_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_details_screen.dart';
import 'screens/search_screen.dart';
import 'services/favourites_provider.dart';
import 'theme/app_theme.dart';

/// CINEMATE - A Simple and Beautiful Movie Discovery Application
/// 
/// Main entry point of the Flutter application.
/// 
/// Demonstrates:
/// - runApp()
/// - ChangeNotifierProvider for app-wide favourite movies state
/// - MaterialApp configuration with ThemeData
/// - Named routes and route generation
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavouritesProvider(),
      child: const CinemateApp(),
    ),
  );
}

class CinemateApp extends StatelessWidget {
  const CinemateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CINEMATE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        FavouritesScreen.routeName: (context) => const FavouritesScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
        // Named route handler for MovieDetailsScreen with arguments
        if (settings.name == MovieDetailsScreen.routeName) {
          final movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          );
        }
        return null;
      },
    );
  }
}
