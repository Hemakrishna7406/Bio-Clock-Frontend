import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/core/app_theme.dart';
import '../../../shared/core/app_settings_provider.dart';
import '../../../shared/ui/glass_card.dart';
import '../../../shared/ui/status_orb.dart';
import '../../../shared/ui/animated_counter.dart';

/// Reimagined Home page — Discovery Hub.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = context.ext;
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Theme.of(context)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.92),
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                const Text('Bio Clock',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),

                // ── Hero Orb Section ────────────
                Center(
                  child: const StatusOrb(
                    size: 130,
                    color: AppTheme.accentGreen,
                    label: 'Bio-Clock AI Ready',
                    sublabel: 'Freshness Analysis Engine',
                  ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        curve: Curves.easeOutBack,
                      ),
                ),

                const SizedBox(height: 28),

                // ── Gradient Title ──────────
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.gradientPrimary.createShader(bounds),
                  child: const Text(
                    'Bio Clock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

                const SizedBox(height: 8),
                Text(
                  'AI-powered food freshness monitoring\nfor smarter produce management',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: ext.textMuted,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 28),

                // ── Impact Stats Row ───────────
                if (settings.demoMode) ...[
                  const Row(
                    children: [
                      Expanded(
                        child: GlassCard(
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.eco,
                                        size: 16, color: AppTheme.accentGreen),
                                    SizedBox(width: 8),
                                    Text('CO₂ Saved',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.accentGreen,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 12),
                                AnimatedCounter(
                                    value: 12500,
                                    suffix: 'g',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: GlassCard(
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.savings,
                                        size: 16, color: AppTheme.accentAmber),
                                    SizedBox(width: 8),
                                    Text('Money Saved',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.accentAmber,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 12),
                                AnimatedCounter(
                                    value: 3450,
                                    prefix: '₹',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 500.ms)
                      .slideY(begin: 0.12),
                  const SizedBox(height: 24),
                ],

                // ── Feature Walkthrough Cards ──
                Text(
                  'WHY BIO CLOCK MATTERS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: ext.textMuted,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 14),

                Column(
                  children: [
                    _verticalFeatureCard(
                      context,
                      icon: Icons.qr_code_scanner,
                      color: AppTheme.accentGreen,
                      title: 'Smart Scanning',
                      description:
                          'AI-powered camera auto-detects produce and analyzes freshness in seconds.',
                    ),
                    const SizedBox(height: 20),
                    _verticalFeatureCard(
                      context,
                      icon: Icons.show_chart,
                      color: AppTheme.accentCyan,
                      title: 'Live Graph',
                      description:
                          'Real-time RUL tracking with weather-synced environmental simulation.',
                    ),
                    const SizedBox(height: 20),
                    _verticalFeatureCard(
                      context,
                      icon: Icons.inventory_2,
                      color: AppTheme.accentPurple,
                      title: 'Inventory',
                      description:
                          'Track all produce with status updates and batch predictions.',
                    ),
                    const SizedBox(height: 20),
                    _verticalFeatureCard(
                      context,
                      icon: Icons.health_and_safety,
                      color: AppTheme.accentAmber,
                      title: 'AI Preservation',
                      description:
                          'Get smart storage tips to extend freshness and reduce waste.',
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms),

                const SizedBox(height: 28),

                // ── Science Behind the Clock ──
                Text(
                  'SCIENCE BEHIND THE CLOCK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: ext.textMuted,
                  ),
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 14),

                _buildScienceSection(context)
                    .animate()
                    .fadeIn(delay: 850.ms, duration: 600.ms),

                const SizedBox(height: 20),

                // ── Impact Stats ───────────────
                Row(
                  children: [
                    _featureStat(ext, '85%+', 'Accuracy'),
                    const SizedBox(width: 10),
                    _featureStat(ext, '< 3s', 'Scan Time'),
                    const SizedBox(width: 10),
                    _featureStat(ext, '61', 'Produce'),
                  ],
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalFeatureCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: GlassCard(
        gradientBorder: true,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.ext.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScienceSection(BuildContext context) {
    final ext = context.ext;
    return GlassCard(
      gradientBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.psychology,
                      color: AppTheme.accentPurple, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Neuro-Symbolic AI Engine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Bio Clock uses Claude Haiku for neuro-symbolic reasoning — '
              'translating visual freshness cues and environmental stress into '
              'precise shelf-life predictions.',
              style: TextStyle(
                fontSize: 13,
                color: ext.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),

            // Q10 Formula
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ext.surfaceDim,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.accentGreen.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Q₁₀ = 2.0 ^ (ΔT / 10.0)',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The Q10 coefficient models how temperature accelerates '
                    'molecular decay in produce — every 10°C increase roughly '
                    'doubles the spoilage rate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: ext.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // How it works steps
            _scienceStep(context, '1', 'Scan produce with your camera',
                AppTheme.accentGreen),
            _scienceStep(context, '2',
                'AI analyzes visual & environmental data', AppTheme.accentCyan),
            _scienceStep(
                context,
                '3',
                'Q10 model predicts remaining useful life',
                AppTheme.accentPurple),
            _scienceStep(context, '4', 'Smart preservation tips delivered',
                AppTheme.accentAmber),
          ],
        ),
      ),
    );
  }

  Widget _scienceStep(
      BuildContext context, String step, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(step,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style:
                    TextStyle(fontSize: 13, color: context.ext.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _featureStat(AppThemeExtension ext, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: ext.textMuted)),
        ],
      ),
    );
  }
}
