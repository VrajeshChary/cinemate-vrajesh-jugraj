# PROJECT DOCUMENTATION REPORT
**Course Code:** CS506PC — UI Design – Flutter External Laboratory Examination  
**Academic Year:** 2026 – 2027 | **Semester:** III - I  
**Department:** Computer Science & Engineering (B.Tech - CSE)  
**Institution:** CR Rao AIMSCS  

---

### **Student Information**
- **Student Name:** M Vrajesh Chary  
- **Roll Number / Hall Ticket Number:** 24XV1M0526  
- **Project Title:** CINEMATE — Movie Discovery Application  
- **Project Repository:** https://github.com/VrajeshChary/cinemate-vrajesh-jugraj  
- **Live Deployment:** Vercel Production Environment  

---

## TABLE OF CONTENTS
1. [Application Name and Introduction](#1-application-name-and-introduction)
2. [Purpose and Objectives](#2-purpose-and-objectives)
3. [Tools and Technologies Used](#3-tools-and-technologies-used)
4. [Features and Functionalities Implemented](#4-features-and-functionalities-implemented)
5. [Important Code Snippets & Explanations](#5-important-code-snippets--explanations)
6. [Deployment Details](#6-deployment-details)
7. [Application Screenshots (UI Output)](#7-application-screenshots-ui-output)
8. [Answer Booklet Summary Guide (Quick Exam Reference)](#8-answer-booklet-summary-guide-quick-exam-reference)

---

## 1. APPLICATION NAME AND INTRODUCTION

### **Application Name:** CINEMATE

### **Introduction:**
**CINEMATE** is a modern, responsive movie discovery web and mobile application developed using Google's **Flutter framework** and the **Dart programming language**. Designed primarily for academic evaluation, the application delivers a polished, streaming-platform-like user interface while adhering to beginner-friendly, clean, and maintainable software engineering practices.

CINEMATE enables users to explore trending and popular global cinema, search for specific movies in real time, view detailed movie profiles (including storylines, runtimes, release dates, and audience ratings), and manage a personal bookmarks/favourites list. The application defaults to a crisp, high-contrast **Light Theme** with an instant header toggle to a Netflix-inspired **Dark Cinematic Theme**, providing an optimal viewing experience across diverse ambient lighting conditions and all screen form factors (Mobile, Tablet, Laptop, and Desktop).

---

## 2. PURPOSE AND OBJECTIVES

### **2.1 Purpose**
The core purpose of the CINEMATE project is to demonstrate the practical application of essential Flutter and Dart concepts prescribed in the **UI Design – Flutter (CS506PC)** syllabus. It bridges theoretical mobile application concepts with a working real-world product, highlighting responsive user interface design, state management, asynchronous REST API integration, and automated cloud deployment.

### **2.2 Objectives**
1. **Responsive Multi-Screen UI:** Build an adaptive user interface that responds seamlessly across four device tiers: Mobile (360px–600px), Tablet (601px–1024px), Laptop (1025px–1440px), and Large Desktop (>1440px).
2. **RESTful API Integration:** Consume live external movie metadata from The Movie Database (TMDB) API via asynchronous HTTP `GET` requests (`async`/`await`).
3. **State Management:** Implement clean, predictable state management using Flutter's built-in `StatefulWidget` (`setState`) for local interactions and `Provider` (`ChangeNotifier`) for global states (favourites collection and dynamic theme switching).
4. **Resilient Offline Architecture:** Ensure 100% application uptime by providing an automatic offline fallback dataset of 10 curated HD titles if network connectivity is interrupted.
5. **Form Handling & Input Validation:** Implement input validation mechanisms using `Form`, `GlobalKey<FormState>`, and `TextEditingController`.
6. **Smooth Declarative Navigation:** Utilize Flutter's named routes and declarative navigation with transition animations (`Hero` widget).
7. **CI/CD Cloud Deployment:** Automate building and hosting on Vercel with single-page application (SPA) client-side rewrite rules.

---

## 3. TOOLS AND TECHNOLOGIES USED

| Category | Tool / Technology | Version / Specification | Role in Project |
|:---|:---|:---|:---|
| **Framework** | Flutter | 3.27+ (Stable Channel) | Multi-platform UI toolkit for building Web & Mobile apps from a single codebase |
| **Language** | Dart | 3.6+ | Strongly typed object-oriented programming language with sound null safety |
| **Design System** | Material Design 3 | Material UI Components | Standardized cards, typography, app bars, and responsive grids |
| **State Management**| Provider | ^6.1.2 | `ChangeNotifierProvider` & `MultiProvider` for reactive global state |
| **Networking** | `http` Package | ^1.2.2 | REST API communication, JSON request/response handling |
| **External API** | The Movie Database (TMDB) | API v3 | Live movie metadata, posters, backdrops, vote averages, and runtimes |
| **Testing** | Flutter Test Framework | Built-in | Unit and widget verification tests |
| **Browser Engine** | Microsoft Edge / Chromium | Edge DevTools | Automated headless layout testing and screenshot verification |
| **Version Control** | Git & GitHub | Git 2.40+ | Source code versioning and collaborative tracking |
| **Cloud Hosting** | Vercel | Production Edge Network | Automated CI/CD pipeline, web release build, and SPA deployment |

---

## 4. FEATURES AND FUNCTIONALITIES IMPLEMENTED

### **1. Adaptive Theming (Light Default & Dark Cinematic)**
- Defaults to a crisp Light Theme (`#F6F7F9` background, `#FFFFFF` cards, `#111827` primary typography).
- Interactive Sun/Moon toggle button prominently placed in the top `AppBar` allowing instant switching between Light Mode and Netflix-inspired Dark Cinematic Mode (`#101014` background, `#22222B` cards, `#E50914` red accents).

### **2. Four-Tier Responsive Layout**
- **Mobile (`<= 600px`):** 2-column movie grid, compact header navigation icons, stacked details view.
- **Tablet (`601px – 1024px`):** 3 to 4-column movie grid with balanced touch targets and a 280px featured banner.
- **Laptop (`1025px – 1440px`):** 4 to 5-column grid within a tailored 1240px container, side-by-side theatrical split layout optimized for standard 1366×768 and 1280×800 screens without vertical overflow.
- **Desktop (`> 1440px`):** 6-column widescreen grid, max 1400px centered viewport, full theatrical split view.

### **3. Featured Movie Hero Section**
- Prominently showcases the day's top blockbuster on the Home screen.
- Features a high-resolution backdrop, title, release year, star rating, genre chip, and a "View Details" call-to-action button.

### **4. Trending & Popular Movie Carousels**
- **Trending Movies:** Smooth horizontal scrollable carousel (`ListView.builder`) with customized `MovieCard` widgets.
- **Popular Movies:** Adaptive multi-column grid (`GridView.builder`) with proportional aspect ratios (`0.62`), eliminating empty spacing gaps.

### **5. Real-Time Title Search**
- Interactive search screen with autofocus `TextField`, real-time debounce, clear button (`IconButton`), loading indicator, and intuitive empty-state cards.

### **6. Theatrical Movie Details View**
- Displays large poster artwork, high-resolution backdrop banners, full storyline overviews, release years, runtimes, genres, and vote averages.
- Includes a smooth `Hero` animation transition between cards and the details screen.

### **7. Global Favourites Management**
- Users can toggle favourite status directly from the movie details view or via quick-remove icons in the favourites grid.
- State is preserved app-wide using `FavouritesProvider` (`ChangeNotifier`).

### **8. Offline Data Resilience**
- If the TMDB API is unreachable, the application automatically loads 10 pre-configured high-definition sample movies (`MovieService.sampleMovies`), preventing blank screens or unhandled network exceptions.

---

## 5. IMPORTANT CODE SNIPPETS & EXPLANATIONS

### **Snippet 1: Application Entry Point & MultiProvider (`lib/main.dart`)**
*Demonstrates `runApp()`, `MultiProvider` wiring `FavouritesProvider` and `ThemeProvider`, and named routing:*
```dart
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
      theme: AppTheme.lightTheme,           // Default Light Theme
      darkTheme: AppTheme.darkTheme,        // Dark Cinematic Theme
      themeMode: themeProvider.themeMode,   // Reactive Theme Mode
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        FavouritesScreen.routeName: (context) => const FavouritesScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
    );
  }
}
```

---

### **Snippet 2: Asynchronous TMDB REST API Integration (`lib/services/movie_service.dart`)**
*Demonstrates asynchronous HTTP `GET` requests, JSON deserialization, query filtering, and try-catch error handling:*
```dart
Future<List<Movie>> getPopularMovies() async {
  try {
    final uri = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    }
  } catch (e) {
    // Graceful offline fallback
  }
  return sampleMovies;
}
```

---

### **Snippet 3: Global Theme Management (`lib/services/theme_provider.dart`)**
*Demonstrates `ChangeNotifier`, private state encapsulation, and UI rebuild notification via `notifyListeners()`:*
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default to Light

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); // Triggers app-wide rebuild
  }
}
```

---

### **Snippet 4: Four-Tier Responsive Breakpoint Engine (`lib/screens/home_screen.dart`)**
*Demonstrates `MediaQuery` dimension inspection, responsive grid column calculation, and container width constraints:*
```dart
final screenWidth = MediaQuery.of(context).size.width;

final int crossAxisCount;
final double horizontalPadding;
final double maxContentWidth;

if (screenWidth > 1440) {
  // 1. Desktop (>1440px)
  crossAxisCount = 6;
  horizontalPadding = 36.0;
  maxContentWidth = 1400.0;
} else if (screenWidth > 1024) {
  // 2. Laptop (1025px - 1440px)
  crossAxisCount = screenWidth > 1200 ? 5 : 4;
  horizontalPadding = 28.0;
  maxContentWidth = 1240.0;
} else if (screenWidth > 600) {
  // 3. Tablet (601px - 1024px)
  crossAxisCount = screenWidth > 800 ? 4 : 3;
  horizontalPadding = 20.0;
  maxContentWidth = 960.0;
} else {
  // 4. Mobile (<= 600px)
  crossAxisCount = 2;
  horizontalPadding = 12.0;
  maxContentWidth = double.infinity;
}
```

---

### **Snippet 5: Proportional Grid Movie Card (`lib/widgets/movie_card.dart`)**
*Demonstrates `InkWell` ripple interactions, `Hero` transitions, and `Expanded` widget preventing awkward gaps:*
```dart
Widget build(BuildContext context) {
  final posterWidget = Hero(
    tag: 'movie-poster-${movie.id}',
    child: MoviePoster(
      imageUrl: movie.posterUrl,
      width: isGrid ? double.infinity : width,
      height: isGrid ? double.infinity : posterHeight,
      borderRadius: 10,
      fit: BoxFit.cover,
    ),
  );

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isGrid) Expanded(child: posterWidget) else posterWidget,
        const SizedBox(height: 8),
        Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppTheme.getTextColor(context), fontWeight: FontWeight.w600),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(movie.releaseYear, style: TextStyle(color: AppTheme.getSecondaryTextColor(context))),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppTheme.starRatingColor, size: 16),
                Text(movie.voteAverage.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
```

---

## 6. DEPLOYMENT DETAILS

CINEMATE is configured for continuous integration and automated deployment on **Vercel** with single-page application (SPA) client-side routing.

### **6.1 Deployment Architecture**
1. **GitHub Repository Sync:** The source code is hosted on GitHub (`https://github.com/VrajeshChary/cinemate-vrajesh-jugraj`).
2. **Automated CI/CD Webhook:** Any `git push origin main` triggers an automatic build pipeline on Vercel.
3. **Build Script Execution (`vercel-build.sh`):**
   - Automatically clones the stable Flutter SDK on Vercel's Linux build container.
   - Executes `flutter config --enable-web` and `flutter pub get`.
   - Compiles the application to production JavaScript/Wasm with:
     ```bash
     flutter build web --release --base-href /
     ```
   - Emits the distribution bundle to `build/web`.
4. **SPA Rewrite Rules (`vercel.json`):**
   ```json
   {
     "version": 2,
     "buildCommand": "bash vercel-build.sh",
     "outputDirectory": "build/web",
     "cleanUrls": true,
     "routes": [
       { "handle": "filesystem" },
       { "src": "/(.*)", "dest": "/index.html" }
     ]
   }
   ```
   *Ensures Flutter client-side route navigation (`/#/search`, `/#/favourites`, `/#/about`) functions correctly on page reloads.*

---

## 7. APPLICATION SCREENSHOTS (UI OUTPUT)

> *The following screenshots depict the actual running application outputs captured across different device viewports and screens:*

### **Figure 7.1: Multi-Device Responsive Layouts**
- **Desktop Layout (`> 1440px`):** 6-column grid with labeled top navigation buttons and expanded banner.
- **Laptop Layout (`1025px – 1440px`):** 4 to 5-column grid fitted within a 1240px container tailored for 1366×768 / 1280×800 laptop screens.
- **Tablet Layout (`601px – 1024px`):** 3-column grid with balanced touch spacing.
- **Mobile Layout (`360px – 600px`):** 2-column mobile grid with compact header icons.

### **Figure 7.2: Application Screens**
- **Home Screen:** Featured movie banner, horizontal trending list, and popular movies grid.
- **Movie Details Screen:** Split-view layout with large poster, star ratings, genres, and storyline.
- **Search Screen:** Real-time query field with dynamic results grid and empty-state placeholders.
- **Favourites Screen:** Bookmarked movies collection with instant remove functionality.
- **About Screen:** Project overview, architectural specifications, and student academic credentials.

---

## 8. ANSWER BOOKLET SUMMARY GUIDE (QUICK EXAM REFERENCE)

> **Use this condensed outline to write answers directly in your physical examination answer booklet:**

1. **Application Name:** CINEMATE
2. **What It Does:**
   - A multi-platform movie discovery application that allows users to browse trending and popular movies, search titles in real time, view movie descriptions with ratings, and save favourites.
3. **Purpose & Objectives:**
   - Designed for the CS506PC Lab Examination to demonstrate Flutter widget architecture, responsive layout design across 4 form factors (Mobile, Tablet, Laptop, Desktop), asynchronous REST API integration with TMDB, and global state management using Provider.
4. **Tools & Technologies Used:**
   - **Flutter SDK & Dart:** UI framework and programming language.
   - **Material 3:** Design system for cards, app bars, and responsive grids.
   - **Provider (`ChangeNotifier`):** State management for favourites and Light/Dark theming.
   - **HTTP Package:** REST API communication with The Movie Database (TMDB).
   - **Vercel & Git:** Version control and cloud automated deployment.
5. **Key Features Implemented:**
   - **Default Light Theme** with top-bar instant toggle to **Dark Cinematic Theme**.
   - **4-Tier Responsive Layouts** adapting from 2 columns on phones to 6 columns on widescreen displays.
   - **Hero Animations** for smooth transitions between movie cards and details.
   - **Real-Time Title Search** with `setState` dynamic updates.
   - **Resilient Offline Fallback** with 10 pre-loaded titles.
6. **Development & Deployment Summary:**
   - Developed in VS Code using Flutter & Dart.
   - Tested using `flutter test` (all 4 unit/widget tests passing) and `flutter analyze` (0 issues).
   - Deployed on Vercel using `vercel-build.sh` (automatic Flutter SDK download and web compilation) and `vercel.json` for SPA routing.
