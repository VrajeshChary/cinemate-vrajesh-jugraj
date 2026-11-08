import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/movie.dart';
import 'screens/about_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_details_screen.dart';
import 'screens/search_screen.dart';
import 'services/favourites_provider.dart';
import 'services/theme_provider.dart';
import 'theme/app_theme.dart';

/// CINEMATE - A Simple and Beautiful Movie Discovery Application
/// 
/// Main entry point of the Flutter application.
/// 
/// Demonstrates:
/// - MultiProvider combining FavouritesProvider & ThemeProvider
/// - ThemeMode.light by default with instant toggle
/// - MaterialApp configuration with lightTheme & darkTheme
/// - Named routes and onGenerateRoute
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CinemateApp(),
    ),
  );
}

class CinemateApp extends StatelessWidget {
  const CinemateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'CINEMATE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        FavouritesScreen.routeName: (context) => const FavouritesScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
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
