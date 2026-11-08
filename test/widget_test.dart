import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cinema/main.dart';
import 'package:cinema/models/movie.dart';
import 'package:cinema/screens/movie_details_screen.dart';
import 'package:cinema/services/favourites_provider.dart';
import 'package:cinema/widgets/movie_card.dart';

void main() {
  const testMovie = Movie(
    id: 999,
    title: 'Interstellar Test',
    overview: 'A group of explorers travel through a wormhole in space.',
    posterPath: 'https://image.tmdb.org/t/p/w500/sample.jpg',
    releaseYear: '2014',
    voteAverage: 8.7,
    genre: 'Sci-Fi',
    runtime: '169 min',
  );

  testWidgets('1. Test that the CINEMATE app renders and displays application name', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => FavouritesProvider(),
        child: const CinemateApp(),
      ),
    );

    // Verify that the application title "CINEMATE" is displayed in the AppBar
    expect(find.text('CINEMATE'), findsOneWidget);
  });

  testWidgets('2. Test that MovieCard displays its movie title and release year', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(
            movie: testMovie,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify title and release year are displayed
    expect(find.text('Interstellar Test'), findsOneWidget);
    expect(find.text('2014'), findsOneWidget);
    expect(find.text('8.7'), findsOneWidget);
  });

  testWidgets('3. Test basic favourite functionality via FavouritesProvider', (WidgetTester tester) async {
    final provider = FavouritesProvider();

    // Initial state: movie is not favourite
    expect(provider.isFavourite(testMovie), isFalse);
    expect(provider.favourites.length, 0);

    // Add to favourites
    provider.toggleFavourite(testMovie);
    expect(provider.isFavourite(testMovie), isTrue);
    expect(provider.favourites.length, 1);
    expect(provider.favourites.first.title, 'Interstellar Test');

    // Remove from favourites
    provider.removeFavourite(testMovie);
    expect(provider.isFavourite(testMovie), isFalse);
    expect(provider.favourites.length, 0);
  });

  testWidgets('4. Test MovieDetailsScreen renders movie information properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => FavouritesProvider(),
        child: const MaterialApp(
          home: MovieDetailsScreen(movie: testMovie),
        ),
      ),
    );

    // Verify title, genre, runtime, and storyline exist on details screen
    expect(find.text('Interstellar Test'), findsOneWidget);
    expect(find.text('Sci-Fi'), findsOneWidget);
    expect(find.text('169 min'), findsOneWidget);
    expect(find.text('Storyline'), findsOneWidget);
    expect(find.text(testMovie.overview), findsOneWidget);
  });
}
