import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// AboutScreen displays app branding and academic project details.
/// 
/// Demonstrates:
/// - StatelessWidget
/// - Constrained layout for desktop (max 800px)
/// - Clean card hierarchy and dark cinematic styling
class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('About CINEMATE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Branding Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.secondaryBackground),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.movie_creation_outlined,
                          size: 52,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'CINEMATE',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Version 1.0.0 (Academic Edition)',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'A simple and beautiful movie discovery application built with Flutter & Dart. '
                        'Explore trending blockbusters, search titles in real time, and curate your favourites in an elegant dark cinematic interface.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Project Architecture & Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cardColor),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.code_rounded, color: AppTheme.primaryAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Project Architecture & Details',
                            style: TextStyle(
                              color: AppTheme.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Framework: Flutter & Dart (Web, Mobile, Desktop)\n'
                        '• Responsive Breakpoints: Mobile (<=600px), Tablet (601-1024px), Desktop (>1024px)\n'
                        '• State Management: setState & Provider (ChangeNotifier)\n'
                        '• API Integration: The Movie Database (TMDB) REST API (Active Key)\n'
                        '• Styling: Netflix-inspired Dark Cinematic Theme (#101014 / #E50914)\n'
                        '• Developer: Student Academic Assignment',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Application Highlights Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cardColor),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_outline_rounded, color: AppTheme.primaryAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Core Capabilities',
                            style: TextStyle(
                              color: AppTheme.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Real-time title search with instantaneous query matching\n'
                        '• Bookmarked favourites synchronization across all application screens\n'
                        '• Detailed storylines, runtimes, release years, and live star ratings\n'
                        '• Graceful offline fallback with 10 pre-loaded high-resolution sample titles',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
