import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/core/app_theme.dart';
import '../../../shared/ui/glass_card.dart';
import '../data/bio_scanner.dart';

class LabScreen extends ConsumerStatefulWidget {
  const LabScreen({super.key});

  @override
  ConsumerState<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends ConsumerState<LabScreen> {
  bool _showWork = false;
  final Map<String, dynamic>? _verdict = null;

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;

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
            title: const Text('Gen-AI Insights Lab',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Scan produce to analyze freshness',
                  style: TextStyle(color: ext.textMuted, fontSize: 14),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 20),

                // ── Bio Scanner ─────────────
                const BioScanner()
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 600.ms),

                const SizedBox(height: 24),

                // ── Verdict Card ────────────
                if (_verdict != null)
                  _buildVerdictCard(context)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15)
                else
                  _buildPlaceholderVerdict(context)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 24),

                // ── Recipe Suggestions ──────
                Text(
                  'RECIPE SUGGESTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: ext.textMuted,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 14),
                ..._recipes.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _recipeCard(context, e.value)
                          .animate()
                          .fadeIn(
                              delay: (350 + e.key * 80).ms, duration: 400.ms)
                          .slideX(begin: 0.08),
                    )),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderVerdict(BuildContext context) {
    final ext = context.ext;
    return GlassCard(
      gradientBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.biotech, size: 40, color: ext.textMuted),
            const SizedBox(height: 12),
            Text(
              'Scan a food item to see AI analysis',
              style: TextStyle(color: ext.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdictCard(BuildContext context) {
    final ext = context.ext;
    return GlassCard(
      gradientBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 22),
                SizedBox(width: 10),
                Text('Fresh • 85% confidence',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),

            // Confidence bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.85,
                minHeight: 6,
                backgroundColor: ext.glassBackground,
                color: AppTheme.accentGreen,
              ),
            ),
            const SizedBox(height: 16),

            // Show work toggle
            InkWell(
              onTap: () => setState(() => _showWork = !_showWork),
              child: Row(
                children: [
                  Icon(
                    _showWork ? Icons.expand_less : Icons.expand_more,
                    color: ext.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Show Your Work',
                      style: TextStyle(fontSize: 12, color: ext.textMuted)),
                ],
              ),
            ),
            if (_showWork) ...[
              const SizedBox(height: 12),
              Text(
                'Model: Claude 4.5 Haiku via Amazon Bedrock\n'
                'Features: color_uniformity=0.92, texture_score=0.87\n'
                'Q10 Factor: 1.41× at 25°C',
                style: TextStyle(
                    fontSize: 11, color: ext.textSecondary, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static const _recipes = [
    _Recipe('Spinach Smoothie', '5 min · 120 cal', '🥬'),
    _Recipe('Quick Tomato Soup', '15 min · 180 cal', '🍅'),
    _Recipe('Mixed Veggie Stir-fry', '10 min · 200 cal', '🥘'),
  ];

  Widget _recipeCard(BuildContext context, _Recipe recipe) {
    final ext = context.ext;
    return GlassCard(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(recipe.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(recipe.meta,
                      style: TextStyle(fontSize: 11, color: ext.textMuted)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: ext.textMuted),
          ],
        ),
      ),
    );
  }
}

class _Recipe {
  final String name;
  final String meta;
  final String emoji;

  const _Recipe(this.name, this.meta, this.emoji);
}
