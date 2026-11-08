# CINEMATE 🎬
> A Simple, Beautiful Movie Discovery Application built with Flutter & Dart.

CINEMATE is a modern movie discovery app featuring a dark cinematic theme inspired by Netflix. Designed specifically as an academic showcase, it maintains clean, beginner-friendly code while delivering a polished UI/UX experience.

---

## 🌟 Key Features

1. **Cinematic Dark Theme**: Custom dark theme with Netflix-inspired red accents (`#E50914`) and sleek card styling.
2. **Featured Movie Banner**: Highlighting today's top blockbuster with high-resolution poster backdrop and gradient overlay.
3. **Trending & Popular Sections**: 
   - Horizontal scrollable list for *Trending Movies*.
   - Responsive 2-column grid for *Popular Movies* (adapts to 3 columns on larger displays).
4. **Real-time Movie Search**: Filter and search through movies by title with instant `setState` UI updates and empty-state feedback.
5. **Detailed Movie View**: Rich movie overview with runtime, release year, star ratings, storyline, and `Hero` transition animations.
6. **Favourites System**: Add and remove favourite movies with cross-screen state persistence powered by `Provider`.
7. **About & Feedback Form**: Minimalist about screen with full input validation (`Form`, `GlobalKey<FormState>`, `TextEditingController`, and regex email validation).
8. **REST API Ready**: Connects to The Movie Database (TMDB) API with built-in instant fallback to 10 curated HD sample movies when offline or without an API key.

---

## 📁 Project Structure

```text
cinema/
├── lib/
│   ├── main.dart                       # App entry point, MaterialApp & Routes
│   ├── dart_basics.dart                # Dart fundamental concepts demo
│   ├── models/
│   │   └── movie.dart                  # Movie model & JSON deserialization
│   ├── services/
│   │   ├── movie_service.dart          # TMDB API calls & offline sample data
│   │   └── favourites_provider.dart    # ChangeNotifier for favourites state
│   ├── theme/
│   │   └── app_theme.dart              # Color palette & ThemeData configuration
│   ├── widgets/
│   │   ├── movie_card.dart             # Reusable movie card widget
│   │   ├── movie_poster.dart           # Image loader with placeholder & error handling
│   │   └── section_title.dart          # Section header with red accent bar
│   └── screens/
│       ├── home_screen.dart            # Main feed (featured, trending, popular)
│       ├── movie_details_screen.dart   # Detailed view with storyline & actions
│       ├── search_screen.dart          # Search bar & results grid
│       ├── favourites_screen.dart      # Bookmarked movies list & remove action
│       └── about_screen.dart           # Project info & feedback form with validation
├── test/
│   └── widget_test.dart                # Unit & widget tests for screens & state
├── pubspec.yaml                        # Project metadata & dependencies
└── analysis_options.yaml               # Standard Flutter linter rules
```

---

## 🚀 How to Run the Application

### 1. Prerequisites (If Flutter is not yet installed)
If Flutter is not yet installed on your system:
1. Download Flutter SDK for Windows from [flutter.dev](https://docs.flutter.dev/get-started/install/windows).
2. Extract the zip file to `C:\src\flutter`.
3. Add `C:\src\flutter\bin` to your system environment `PATH` variable.
4. Open a new terminal and run:
   ```bash
   flutter doctor
   ```

### 2. Getting Dependencies
In the project root folder (`d:\Hacksmiths United\cinema`), run:
```bash
flutter pub get
```

### 3. Running the App
Run on Chrome (Web), Windows Desktop, or an Android/iOS emulator:
```bash
# Run on Chrome
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows

# Run on connected device/emulator
flutter run
```

### 4. Running the Tests
Execute the unit and widget tests:
```bash
flutter test
```

### 5. Running the Dart Basics Demonstration
Run the standalone Dart fundamentals file directly:
```bash
dart run lib/dart_basics.dart
```

---

## 🔑 Adding a TMDB API Key (Optional)

The app works **immediately out-of-the-box** using 10 preloaded curated HD movies with working posters and descriptions.

To connect live TMDB data:
1. Create a free account at [themoviedb.org](https://www.themoviedb.org/).
2. Go to **Settings > API** to generate your free API key (v3 auth).
3. Open `lib/services/movie_service.dart`.
4. Replace `static const String apiKey = '';` with your key:
   ```dart
   static const String apiKey = 'your_actual_tmdb_api_key_here';
   ```
5. Save and restart the app.

---

## 🎓 Academic Viva & Practical Examination Guide

### 1. What state management is used?
- **Local Screen State (`setState`)**: Used in `HomeScreen`, `SearchScreen`, and `AboutScreen` for loading spinners, search input text, and form validation.
- **Global Cross-Screen State (`Provider`)**: `FavouritesProvider` extends `ChangeNotifier` to manage the list of favourite movies. It notifies listeners (`notifyListeners()`) so changes immediately update both `FavouritesScreen` and `MovieDetailsScreen`.

### 2. How is navigation handled?
- **Named Routes**: Declared in `MaterialApp.routes` (`'/'`, `'/search'`, `'/favourites'`, `'/about'`).
- **Route Arguments**: Parameterized transitions (e.g. passing a `Movie` object to `MovieDetailsScreen`) use `MaterialPageRoute` and `onGenerateRoute`.

### 3. How does responsive layout work?
- `MediaQuery.of(context).size.width` is used to dynamically switch grid layouts between 2 columns on mobile devices and 3 columns on tablets or desktops.
