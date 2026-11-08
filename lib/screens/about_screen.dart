import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// AboutScreen with 3-Level Responsive Design and Form Validation.
/// 
/// Demonstrates:
/// - Constrained layout for desktop (max 800px)
/// - Form, GlobalKey<FormState>, and TextEditingControllers
/// - Input validation (required field, email regex)
/// - SnackBar user feedback
class AboutScreen extends StatefulWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you $name! Your feedback has been received.'),
          backgroundColor: Colors.green[800],
          behavior: SnackBarBehavior.floating,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _feedbackController.clear();
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

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
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.secondaryBackground),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.movie_creation_outlined,
                          size: 48,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CINEMATE',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Version 1.0.0 (Academic Edition)',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'A simple and beautiful movie discovery application built with Flutter & Dart. '
                        'Explore trending movies, search your favourites, and read storylines in an elegant dark cinematic interface.',
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
                const SizedBox(height: 24),

                // Developer / College Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Architecture & Details',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Framework: Flutter & Dart (Web, Mobile, Desktop)\n'
                        '• Responsive Breakpoints: Mobile (<=600px), Tablet (601-1024px), Desktop (>1024px)\n'
                        '• State Management: setState & Provider (ChangeNotifier)\n'
                        '• API Integration: The Movie Database (TMDB) REST API (Active Key)\n'
                        '• Developer: Student Academic Assignment',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Feedback Form Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Send Us Feedback',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: AppTheme.primaryText),
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          labelStyle: TextStyle(color: AppTheme.secondaryText),
                          prefixIcon: Icon(Icons.person_outline, color: AppTheme.secondaryText),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppTheme.primaryText),
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: AppTheme.secondaryText),
                          prefixIcon: Icon(Icons.email_outlined, color: AppTheme.secondaryText),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Feedback Field
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 3,
                        style: const TextStyle(color: AppTheme.primaryText),
                        decoration: const InputDecoration(
                          labelText: 'Your Feedback / Comment',
                          labelStyle: TextStyle(color: AppTheme.secondaryText),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Icon(Icons.chat_bubble_outline, color: AppTheme.secondaryText),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _submitFeedback,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Submit Feedback'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
