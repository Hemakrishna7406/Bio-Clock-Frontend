import 'package:flutter/material.dart';
import '../../../shared/core/app_theme.dart';
import '../../../shared/ui/glass_card.dart';

/// Bio-Scanner card with animated scan-line, corner brackets, and capture flow.
class BioScanner extends StatefulWidget {
  final Function(String)? onImageCaptured;
  final bool isAnalyzing;

  const BioScanner({
    super.key,
    this.onImageCaptured,
    this.isAnalyzing = false,
  });

  @override
  State<BioScanner> createState() => _BioScannerState();
}

class _BioScannerState extends State<BioScanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLine;

  @override
  void initState() {
    super.initState();
    _scanLine = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanLine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final isDark = context.isDark;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bio-Scanner',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auto-capture at 85% confidence',
                      style: TextStyle(fontSize: 12, color: ext.textMuted),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.accentGreen.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.accentGreen,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Camera viewport
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ext.glassBorder),
                ),
                child: Stack(
                  children: [
                    // Corner brackets
                    ..._cornerBrackets(),

                    // Scan line
                    if (!widget.isAnalyzing)
                      AnimatedBuilder(
                        animation: _scanLine,
                        builder: (context, _) {
                          return Positioned(
                            top: _scanLine.value *
                                (MediaQuery.of(context).size.width * 0.65),
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.accentGreen.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentGreen
                                        .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Center content
                    Center(
                      child: widget.isAnalyzing
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppTheme.accentGreen,
                                    backgroundColor: AppTheme.accentGreen
                                        .withValues(alpha: 0.15),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Analyzing with Claude 4.5…',
                                  style: TextStyle(
                                    color: ext.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.center_focus_strong_outlined,
                                  size: 40,
                                  color: ext.textMuted,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Position produce in frame',
                                  style: TextStyle(
                                    color: ext.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _captureButton(),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Info bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ext.surfaceDim,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: ext.textMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Scanner auto-captures when confidence ≥ 85%',
                      style: TextStyle(fontSize: 12, color: ext.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _captureButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.neonGlow(AppTheme.accentGreen, intensity: 0.3),
      ),
      child: ElevatedButton.icon(
        onPressed: () =>
            widget.onImageCaptured?.call('/mock/path/to/image.jpg'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        icon: const Icon(Icons.camera, size: 18),
        label: const Text('Start Scanner'),
      ),
    );
  }

  List<Widget> _cornerBrackets() {
    const size = 24.0;
    const thickness = 3.0;
    const color = AppTheme.accentGreen;
    const offset = 10.0;

    Widget bracket(Alignment align) {
      final isTop = align == Alignment.topLeft || align == Alignment.topRight;
      final isLeft =
          align == Alignment.topLeft || align == Alignment.bottomLeft;

      return Positioned(
        top: isTop ? offset : null,
        bottom: !isTop ? offset : null,
        left: isLeft ? offset : null,
        right: !isLeft ? offset : null,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _BracketPainter(
              alignment: align,
              color: color.withValues(alpha: 0.7),
              strokeWidth: thickness,
            ),
          ),
        ),
      );
    }

    return [
      bracket(Alignment.topLeft),
      bracket(Alignment.topRight),
      bracket(Alignment.bottomLeft),
      bracket(Alignment.bottomRight),
    ];
  }
}

class _BracketPainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double strokeWidth;

  _BracketPainter({
    required this.alignment,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (alignment == Alignment.topLeft) {
      path.moveTo(0, h);
      path.lineTo(0, 0);
      path.lineTo(w, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(0, 0);
      path.lineTo(w, 0);
      path.lineTo(w, h);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, h);
      path.lineTo(w, h);
    } else {
      path.moveTo(w, 0);
      path.lineTo(w, h);
      path.lineTo(0, h);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
