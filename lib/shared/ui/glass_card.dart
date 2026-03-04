import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Premium glassmorphism card — theme-aware.
/// Uses [AppThemeExtension] for colors so it adapts to light/dark mode.
class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool gradientBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.gradientBorder = false,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _pressed = false;

  BorderRadius get _radius =>
      widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusLg);

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isDark ? AppTheme.glassBlurSigma : 4,
          sigmaY: isDark ? AppTheme.glassBlurSigma : 4,
        ),
        child: AnimatedContainer(
          duration: AppTheme.durationFast,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? ext.glassBackground,
            borderRadius: _radius,
            border: widget.gradientBorder
                ? null
                : Border.all(color: ext.glassBorder),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: widget.padding != null
              ? Padding(padding: widget.padding!, child: widget.child)
              : widget.child,
        ),
      ),
    );

    // Soft gradient border (less saturated than before)
    if (widget.gradientBorder) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: _radius,
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppTheme.accentGreen.withValues(alpha: 0.5),
                    AppTheme.accentCyan.withValues(alpha: 0.3),
                  ]
                : [
                    AppTheme.accentGreen.withValues(alpha: 0.4),
                    AppTheme.accentCyan.withValues(alpha: 0.2),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(1.2),
        child: card,
      );
    }

    if (widget.onTap == null) return card;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppTheme.durationFast,
        child: card,
      ),
    );
  }
}
