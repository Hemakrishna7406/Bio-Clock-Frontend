import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/core/app_theme.dart';
import '../../../shared/ui/glass_card.dart';

class AgentScreen extends ConsumerStatefulWidget {
  const AgentScreen({super.key});

  @override
  ConsumerState<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends ConsumerState<AgentScreen> {
  bool _notifications = true;
  bool _autoScan = false;
  bool _demoMode = true;

  @override
  Widget build(BuildContext context) {
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientPurpleCyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.smart_toy,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                const Text('AI Agent',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _AgentStatusCard()
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: 24),
                const Text('Quick Actions',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700))
                    .animate()
                    .fadeIn(delay: 100.ms),
                const SizedBox(height: 14),
                _actionCard(
                    context,
                    'Scan Food Item',
                    'Analyze freshness with AI vision',
                    Icons.camera_alt,
                    AppTheme.accentCyan,
                    0),
                const SizedBox(height: 10),
                _actionCard(
                    context,
                    'Get Recipe Suggestions',
                    'Based on your current inventory',
                    Icons.restaurant_menu,
                    AppTheme.accentPurple,
                    1),
                const SizedBox(height: 10),
                _actionCard(
                    context,
                    'Waste Report',
                    'View your savings & impact stats',
                    Icons.pie_chart,
                    AppTheme.accentAmber,
                    2),
                const SizedBox(height: 10),
                _actionCard(
                    context,
                    'Batch Predict',
                    'Run Q10 model on entire inventory',
                    Icons.auto_awesome,
                    AppTheme.accentGreen,
                    3),
                const SizedBox(height: 28),
                const Text('Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700))
                    .animate()
                    .fadeIn(delay: 500.ms),
                const SizedBox(height: 14),
                _settingsCard(context)
                    .animate()
                    .fadeIn(delay: 550.ms, duration: 500.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, int index) {
    final ext = context.ext;
    return GlassCard(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: ext.textMuted)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: ext.textMuted),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (200 + index * 80).ms, duration: 400.ms)
        .slideX(begin: 0.08);
  }

  Widget _settingsCard(BuildContext context) {
    final ext = context.ext;
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _toggleRow(
              context: context,
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Alert before items expire',
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            Divider(color: ext.glassBorder, height: 1, indent: 56),
            _toggleRow(
              context: context,
              icon: Icons.qr_code_scanner,
              title: 'Auto-Scan Mode',
              subtitle: 'Auto-capture when produce detected',
              value: _autoScan,
              onChanged: (v) => setState(() => _autoScan = v),
            ),
            Divider(color: ext.glassBorder, height: 1, indent: 56),
            _toggleRow(
              context: context,
              icon: Icons.science_outlined,
              title: 'Demo Mode',
              subtitle: 'Use mock data instead of live API',
              value: _demoMode,
              onChanged: (v) => setState(() => _demoMode = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final ext = context.ext;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: ext.textMuted, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 11, color: ext.textMuted)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.accentGreen;
              }
              return ext.textMuted;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.accentGreen.withValues(alpha: 0.3);
              }
              return ext.glassBackground;
            }),
          ),
        ],
      ),
    );
  }
}

// ── Agent Status Card ───────────────────────────────────────────

class _AgentStatusCard extends StatefulWidget {
  @override
  State<_AgentStatusCard> createState() => _AgentStatusCardState();
}

class _AgentStatusCardState extends State<_AgentStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) {
                    return Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGreen
                                .withValues(alpha: 0.5 * _pulse.value),
                            blurRadius: 10 * _pulse.value,
                            spreadRadius: 2 * _pulse.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'Agent Online',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'v4.5 Haiku',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Your AI assistant is ready to help manage food freshness, '
              'predict spoilage patterns, and suggest optimal storage strategies.',
              style: TextStyle(
                color: ext.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _capBadge(context, 'Vision Analysis'),
                _capBadge(context, 'Q10 Modeling'),
                _capBadge(context, 'Recipe Gen'),
                _capBadge(context, 'Batch Predict'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _capBadge(BuildContext context, String text) {
    final ext = context.ext;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ext.glassBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ext.glassBorder),
      ),
      child:
          Text(text, style: TextStyle(fontSize: 10, color: ext.textSecondary)),
    );
  }
}
