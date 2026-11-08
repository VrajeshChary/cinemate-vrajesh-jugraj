import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable SectionTitle widget.
/// 
/// Demonstrates:
/// - StatelessWidget
/// - Row and Container styling
/// - Consistent typography
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.getTextColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
