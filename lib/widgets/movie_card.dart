import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import 'movie_poster.dart';

/// Reusable MovieCard widget.
/// 
/// Demonstrates:
/// - StatelessWidget
/// - InkWell for tap interactions with ripple effect
/// - Column and Row layouts
/// - Text truncation with TextOverflow.ellipsis
/// - Star rating display
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double width;
  final double posterHeight;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 140,
    this.posterHeight = 190,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with Hero animation
            Hero(
              tag: 'movie-poster-${movie.id}',
              child: MoviePoster(
                imageUrl: movie.posterUrl,
                width: width,
                height: posterHeight,
                borderRadius: 10,
              ),
            ),
            const SizedBox(height: 8),

            // Movie Title
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Release Year and Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie.releaseYear,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppTheme.starRatingColor,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
