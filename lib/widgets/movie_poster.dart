import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable MoviePoster widget.
/// 
/// Demonstrates:
/// - StatelessWidget
/// - ClipRRect for rounded corners
/// - Image.network with loadingBuilder and errorBuilder for robust network handling
/// - Clean dark fallback placeholder
class MoviePoster extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const MoviePoster({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: AppTheme.secondaryBackground,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.secondaryBackground,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie_outlined, color: AppTheme.secondaryText, size: 36),
                    SizedBox(height: 6),
                    Text(
                      'No Image',
                      style: TextStyle(color: AppTheme.secondaryText, fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
