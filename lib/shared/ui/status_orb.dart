import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Multi-ring breathing orb that communicates AI readiness.
/// Three concentric rings pulse at staggered intervals with neon glow.
class StatusOrb extends StatefulWidget {
  final double size;
  final Color color;
  final String? label;
  final String? sublabel;

  const StatusOrb({
    super.key,
    this.size = 140,
    this.color = AppTheme.accentGreen,
    this.label,
    this.sublabel,
  });

  @override
  State<StatusOrb> createState() => _StatusOrbState();
}

class _StatusOrbState extends State<StatusOrb> with TickerProviderStateMixin {
  late AnimationController _ring1;
  late AnimationController _ring2;
  late AnimationController _ring3;

  late Animation<double> _pulse1;
  late Animation<double> _pulse2;
  late Animation<double> _pulse3;

  @override
  void initState() {
    super.initState();

    _ring1 = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _ring2 = AnimationController(
      duration: const Duration(milliseconds: 3200),
      vsync: this,
    )..repeat(reverse: true);

    _ring3 = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    _pulse1 = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _ring1, curve: Curves.easeInOut),
    );
    _pulse2 = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _ring2, curve: Curves.easeInOut),
    );
    _pulse3 = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _ring3, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    _ring3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final s = widget.size;
    final ext = context.ext;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: s,
            height: s,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring 3 — outermost (faint)
                AnimatedBuilder(
                  animation: _pulse3,
                  builder: (_, __) => _buildRing(
                    s * 0.95 * _pulse3.value,
                    color.withValues(alpha: 0.06),
                    color.withValues(alpha: 0.02),
                  ),
                ),
                // Ring 2 — middle
                AnimatedBuilder(
                  animation: _pulse2,
                  builder: (_, __) => _buildRing(
                    s * 0.65 * _pulse2.value,
                    color.withValues(alpha: 0.12),
                    color.withValues(alpha: 0.06),
                  ),
                ),
                // Ring 1 — inner bright
                AnimatedBuilder(
                  animation: _pulse1,
                  builder: (_, __) => _buildRing(
                    s * 0.4 * _pulse1.value,
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0.15),
                  ),
                ),
                // Core dot
                Container(
                  width: s * 0.18,
                  height: s * 0.18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: AppTheme.neonGlow(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          if (widget.sublabel != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.sublabel!,
              style: TextStyle(fontSize: 12, color: ext.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRing(double diameter, Color fill, Color stroke) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: stroke, width: 1.5),
      ),
    );
  }
}
