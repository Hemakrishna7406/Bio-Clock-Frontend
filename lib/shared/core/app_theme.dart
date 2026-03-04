import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bio-Clock Pulse — Design System (Light + Dark)
///
/// Softer, professional palette. No harsh neon gradients.
class AppTheme {
  AppTheme._();

  // ── Core Palette — Dark ───────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F1420);
  static const Color surfaceDark = Color(0xFF1A2030);
  static const Color surfaceLightDark = Color(0xFF252D3F);
  static const Color surfaceDimDark = Color(0xFF0C1018);

  // ── Core Palette — Light ──────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightLight = Color(0xFFF0F2F5);
  static const Color surfaceDimLight = Color(0xFFE8ECF0);

  // ── Accent Colors (softened, less neon) ────────────────────────
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentRed = Color(0xFFEF4444);

  // ── Glass Tokens ──────────────────────────────────────────────
  static const double glassBlurSigma = 12.0;

  // ── Animation Durations ───────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 800);
  static const Duration durationBreathing = Duration(milliseconds: 2000);

  // ── Rounded Radius ────────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusRound = 100;

  // ── Neon Glow Shadows ─────────────────────────────────────────
  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.5}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.25 * intensity),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.1 * intensity),
        blurRadius: 20,
        spreadRadius: 4,
      ),
    ];
  }

  // ── Gradient Presets (softened) ─────────────────────────────────
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [accentGreen, Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientPurpleCyan = LinearGradient(
    colors: [accentPurple, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientAmber = LinearGradient(
    colors: [accentAmber, Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── DARK THEME ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      background: backgroundDark,
      surface: surfaceDark,
      glassBackground: const Color(0x14FFFFFF),
      glassBorder: const Color(0x18FFFFFF),
      textPrimary: Colors.white,
      textSecondary: const Color(0xB3FFFFFF),
      textMuted: const Color(0x66FFFFFF),
    );
  }

  // ── LIGHT THEME ────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: backgroundLight,
      surface: surfaceLight,
      glassBackground: const Color(0x0A000000),
      glassBorder: const Color(0x14000000),
      textPrimary: const Color(0xFF1A1A2E),
      textSecondary: const Color(0xFF4A5568),
      textMuted: const Color(0xFF9CA3AF),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color glassBackground,
    required Color glassBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accentGreen,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accentCyan,
        onSecondary: isDark ? Colors.black : Colors.white,
        tertiary: accentPurple,
        onTertiary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: accentRed,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            height: 1.1,
            letterSpacing: -1.0,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            height: 1.2,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: textSecondary,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: textSecondary,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: textMuted,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: textMuted,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: accentGreen, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: textMuted),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentCyan,
        inactiveTrackColor: glassBackground,
        thumbColor: accentCyan,
        overlayColor: accentCyan.withValues(alpha: 0.15),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
      dividerTheme: DividerThemeData(
        color: glassBorder,
        thickness: 1,
      ),
      // Store custom values via extensions
      extensions: [
        AppThemeExtension(
          glassBackground: glassBackground,
          glassBorder: glassBorder,
          textMuted: textMuted,
          textSecondary: textSecondary,
          surfaceDim: isDark ? surfaceDimDark : surfaceDimLight,
        ),
      ],
    );
  }

  // ── Decorations (theme-aware) ─────────────────────────────────
  static BoxDecoration glassCardDecoration(BuildContext context,
      {double radius = radiusLg, List<BoxShadow>? shadows}) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return BoxDecoration(
      color: ext.glassBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: ext.glassBorder),
      boxShadow: shadows,
    );
  }
}

/// Theme extension to carry custom tokens through [ThemeData].
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color glassBackground;
  final Color glassBorder;
  final Color textMuted;
  final Color textSecondary;
  final Color surfaceDim;

  const AppThemeExtension({
    required this.glassBackground,
    required this.glassBorder,
    required this.textMuted,
    required this.textSecondary,
    required this.surfaceDim,
  });

  @override
  AppThemeExtension copyWith({
    Color? glassBackground,
    Color? glassBorder,
    Color? textMuted,
    Color? textSecondary,
    Color? surfaceDim,
  }) {
    return AppThemeExtension(
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      textMuted: textMuted ?? this.textMuted,
      textSecondary: textSecondary ?? this.textSecondary,
      surfaceDim: surfaceDim ?? this.surfaceDim,
    );
  }

  @override
  AppThemeExtension lerp(
      covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
    );
  }
}

/// Convenience extensions for [BuildContext].
extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textStyles => theme.textTheme;
  AppThemeExtension get ext => theme.extension<AppThemeExtension>()!;
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isWide => MediaQuery.sizeOf(this).width >= 600;
}
