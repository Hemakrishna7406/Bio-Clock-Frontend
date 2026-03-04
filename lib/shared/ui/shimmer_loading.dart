import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_theme.dart';

/// Reusable shimmer skeleton for loading states.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppTheme.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bg = context.ext.glassBackground;

    return Shimmer.fromColors(
      baseColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLightLight,
      highlightColor:
          isDark ? AppTheme.surfaceLightDark : AppTheme.surfaceLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
