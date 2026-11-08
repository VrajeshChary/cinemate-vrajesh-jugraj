# CINEMATE 🎬
> A Simple, Beautiful Movie Discovery Application built with Flutter & Dart.

CINEMATE is a modern, responsive movie discovery application featuring a dark cinematic theme inspired by Netflix. Designed specifically as an academic showcase, it maintains clean, beginner-friendly code while delivering a polished UI/UX experience across Mobile, Tablet, and Desktop web environments.

---

## 📸 Application Screenshots

Actual high-resolution screenshots captured from the running application:

### 1. Three-Level Responsive Layouts

| Desktop Layout (> 1024px) | Tablet Layout (601px - 1024px) | Mobile Layout (360px - 600px) |
|:---:|:---:|:---:|
| ![Desktop View](screenshots/desktop_layout.png) | ![Tablet View](screenshots/tablet_layout.png) | ![Mobile View](screenshots/mobile_layout.png) |
| *5-6 Column Grid & Theatrical Navigation* | *3-4 Column Grid with Balanced Spacing* | *2 Column Grid with Compact Header* |

### 2. Core Application Screens

| Movie Details Screen | Real-Time Search Screen | About & Feedback Form |
|:---:|:---:|:---:|
| ![Movie Details](screenshots/movie_details_screen.png) | ![Search Screen](screenshots/search_screen.png) | ![About Screen](screenshots/about_screen.png) |
| *Theatrical Split View with Live Metadata* | *Live TMDB Title Search with Grid Results* | *Input Validation (Name, Email & Feedback)* |

---

## 🌟 Key Features

1. **Cinematic Dark Theme**: Custom dark theme with Netflix-inspired red accents (`#E50914`), dark cards (`#22222B`), and crisp typography.
2. **Three-Level Responsive Design**:
   - **Mobile (360px–600px)**: 2-column movie grid, compact header icons, stacked details view.
   - **Tablet (601px–1024px)**: 3 to 4-column movie grid, larger banner, optimized touch targets.
   - **Desktop (> 1024px)**: 5 to 6-column grid, max 1280px centered viewport, split-view theatrical details layout, and labeled top navigation.
3. **Featured Movie Banner**: Highlighting today's top blockbuster with high-resolution poster backdrop, rating badge, and action button.
4. **Trending & Popular Sections**: 
   - Horizontal scrollable list for *Trending Movies*.
   - Responsive grid for *Popular Movies*.
5. **Real-time Movie Search**: Filter and search through movies by title with instant `setState` updates, loading progress indicator, and empty-state feedback.
6. **Detailed Movie View**: Rich movie overview with runtime, release year, star ratings, storyline, and `Hero` transition animations.
7. **Favourites System**: Add and remove favourite movies with cross-screen state persistence powered by `Provider`.
8. **About & Feedback Form**: Minimalist about screen with full input validation (`Form`, `GlobalKey<FormState>`, `TextEditingController`, and regex email validation).
9. **Active TMDB REST API**: Configured with live TMDB API key (`d361048f37280ac3a4920d2e64a968a3`) fetching real-time movies, genres, and runtimes, with automatic offline fallback to 10 curated HD sample movies.
10. **Vercel Deployment Ready**: Preconfigured with `vercel.json` (SPA routing) and `vercel-build.sh` (automatic Flutter SDK download & web release compilation).

---

## 📁 Project Structure

```text
cinema/
├── lib/
│   ├── main.dart                       # App entry point, MaterialApp, Theme & Named Routes
│   ├── dart_basics.dart                # Dart fundamental concepts viva demonstration file
│   ├── models/
│   │   └── movie.dart                  # Movie model, JSON serialization, TMDB genre mapping
│   ├── services/
│   │   ├── movie_service.dart          # TMDB API client with live key & offline fallback
│   │   └── favourites_provider.dart    # ChangeNotifier for global favourites state
│   ├── theme/
│   │   └── app_theme.dart              # Dark cinematic color palette & ThemeData
│   ├── widgets/
│   │   ├── movie_card.dart             # Reusable movie card with Hero poster, rating & year
│   │   ├── movie_poster.dart           # Image loader with placeholder & error handling
│   │   └── section_title.dart          # Section header with red accent bar
│   └── screens/
│       ├── home_screen.dart            # Feed: Featured banner, Trending (horizontal), Popular (grid)
│       ├── movie_details_screen.dart   # Theatrical split/stacked view with storyline & actions
│       ├── search_screen.dart          # Search bar & responsive results grid
│       ├── favourites_screen.dart      # Bookmarked movies list & remove action
│       └── about_screen.dart           # Project info & feedback form with validation
├── screenshots/                        # Captured high-resolution screenshots
│   ├── home_screen.png
│   ├── movie_details_screen.png
│   ├── search_screen.png
│   ├── favourites_screen.png
│   ├── about_screen.png
│   ├── desktop_layout.png
│   ├── tablet_layout.png
│   └── mobile_layout.png
├── test/
│   └── widget_test.dart                # Unit & widget tests for screens & state
├── web/                                # Flutter web scaffolding & preloader
│   ├── index.html
│   └── manifest.json
├── vercel.json                         # Vercel deployment configuration
├── vercel-build.sh                     # Automated build script for Vercel
├── pubspec.yaml                        # Project metadata & dependencies
└── analysis_options.yaml               # Standard Flutter linter rules
```

---

## 🚀 How to Run the Application

### 1. Prerequisites (Flutter SDK)
The project is built on Flutter 3.x (Dart 3.x).
Verify your Flutter installation:
```bash
flutter doctor
flutter --version
```

### 2. Getting Dependencies
In the project root folder:
```bash
flutter pub get
```

### 3. Running on Chrome / Web
```bash
# Run on Chrome
flutter run -d chrome

# Run on Edge
flutter run -d edge
```

### 4. Running the Tests
```bash
flutter test
```
*Result: `00:00 +4: All tests passed!`*

### 5. Running Static Code Analysis
```bash
flutter analyze
```
*Result: `No issues found!`*

### 6. Running the Dart Basics Demonstration
Run the standalone Dart fundamentals file directly:
```bash
dart run lib/dart_basics.dart
```

---

## 🧪 Functional Verification Checklist

| Test Item | Status | Verification Detail |
|---|:---:|---|
| **Home Screen Rendering** | ✅ Verified | Featured banner, trending list, popular grid render correctly. |
| **Movie Details Screen** | ✅ Verified | Displays backdrop, title, year, runtime, star rating, storyline. |
| **Search Functionality** | ✅ Verified | Live TMDB query by title returns matching cards with posters. |
| **Favourites Management** | ✅ Verified | Add to favourites from details screen; view and remove in favourites screen. |
| **Form Validation** | ✅ Verified | Name, email regex, and feedback fields validate; displays confirmation SnackBar. |
| **3-Level Responsiveness** | ✅ Verified | Adapts seamlessly across Mobile (<=600px), Tablet (601-1024px), Desktop (>1024px). |
| **Animations** | ✅ Verified | Hero animations on posters, InkWell ripple effects on cards. |
| **Error & Offline Handling** | ✅ Verified | Seamless fallback to 10 curated HD sample movies if offline. |
| **Flutter Analysis** | ✅ Verified | `flutter analyze` reports **0 issues**. |
| **Unit & Widget Tests** | ✅ Verified | All 4 unit and widget tests pass with 100% success rate. |

---

## 🎓 Academic Viva & Practical Examination Guide

### 1. What state management is used?
- **Local Screen State (`setState`)**: Used in `HomeScreen`, `SearchScreen`, and `AboutScreen` for loading spinners, search queries, and form validation.
- **Global Cross-Screen State (`Provider`)**: `FavouritesProvider` extends `ChangeNotifier` to manage the list of favourite movies. It calls `notifyListeners()` so any change immediately updates both `FavouritesScreen` and `MovieDetailsScreen`.

### 2. How is navigation handled?
- **Named Routes**: Declared in `MaterialApp.routes` (`'/'`, `'/search'`, `'/favourites'`, `'/about'`).
- **Route Arguments**: Parameterized transitions (passing a `Movie` object to `MovieDetailsScreen`) use `MaterialPageRoute` and `onGenerateRoute`.

### 3. How does responsive layout work?
- `MediaQuery.of(context).size.width` is used to dynamically adapt grid columns:
  - Mobile (`<= 600px`): 2 columns
  - Tablet (`601px - 1024px`): 3 to 4 columns
  - Desktop (`> 1024px`): 5 to 6 columns inside a centered `ConstrainedBox(maxWidth: 1280)`.
