import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// AboutScreen displays app details, student project info, and a feedback form.
/// 
/// Demonstrates:
/// - StatefulWidget for handling form state
/// - Form, GlobalKey<FormState>, and TextEditingControllers
/// - Input validation (required field, email format regex)
/// - SnackBar for user feedback upon submission
/// - Clean card layout for academic examination presentation
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

      // Reset form after successful submission
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
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('About CINEMATE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Branding Banner
            Container(
              padding: const EdgeInsets.all(20),
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
                      color: AppTheme.primaryAccent.withOpacity(0.15),
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
                      fontSize: 24,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Details',
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Framework: Flutter & Dart\n'
                    '• State Management: setState & Provider\n'
                    '• API: The Movie Database (TMDB) REST API\n'
                    '• Developer: Student Project / College Practical',
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
            const SizedBox(height: 12),

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
                  const SizedBox(height: 12),

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
                      // Basic email validation regex
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

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
                  const SizedBox(height: 20),

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
    );
  }
}
