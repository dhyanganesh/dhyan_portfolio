import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GridCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  const GridCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
  });

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late List<Point<int>> _randomSquares;

  @override
  void initState() {
    super.initState();
    _randomSquares = _generateRandomPattern();
  }

  List<Point<int>> _generateRandomPattern([int length = 5]) {
    final random = Random();
    return List.generate(
      length,
      (_) => Point(random.nextInt(6) + 3, random.nextInt(6) + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        width: widget.width,
        height: widget.height ?? double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F0F13) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: Stack(
          children: [
            // Rotated Grid Pattern Layer
            Positioned(
              left: -50,
              right: -50,
              top: -50,
              bottom: -50,
              child: Transform(
                // React code used -skew-y-12 which is about -0.2 rads
                transform: Matrix4.skewY(-0.2),
                alignment: Alignment.center,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.black, Colors.transparent],
                      stops: [0.0, 0.8],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    // Translate pattern slightly on hover reveal
                    transform: Matrix4.identity()..translate(0.0, _isHovered ? 0.0 : 8.0),
                    child: CustomPaint(
                      painter: _GridPatternPainter(
                        squares: _randomSquares,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Blurred Conic Gradient Hover Reveal
            Positioned(
              left: -50,
              right: -50,
              top: -50,
              bottom: -50,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _isHovered ? 0.25 : 0.0,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: SweepGradient(
                          center: Alignment.center,
                          colors: [
                            Color(0xFFF35066), // 0 deg
                            Color(0xFFF35066), // 117 deg
                            Color(0xFF9071F9), // 180 deg
                            Color(0xFF5182FC), // 240 deg
                            Color(0xFFF35066), // 360 deg
                          ],
                          stops: [0.0, 0.325, 0.5, 0.66, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Foreground Content
            Positioned.fill(
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  final List<Point<int>> squares;
  final bool isDark;

  _GridPatternPainter({required this.squares, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const double step = 30.0;
    
    final paintLine = Paint()
      ..color = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final paintFill = Paint()
      ..color = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintLine);
    }

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintLine);
    }

    // Draw filled squares
    for (final square in squares) {
      final rect = Rect.fromLTWH(
        square.x * step + 1,
        square.y * step + 1,
        step - 1,
        step - 1,
      );
      canvas.drawRect(rect, paintFill);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPatternPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.squares != squares;
  }
}
