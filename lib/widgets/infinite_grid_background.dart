import 'dart:ui';
import 'package:flutter/material.dart';

class InfiniteGridBackground extends StatefulWidget {
  final ValueNotifier<Offset> mouseNotifier;
  const InfiniteGridBackground({super.key, required this.mouseNotifier});

  @override
  State<InfiniteGridBackground> createState() => _InfiniteGridBackgroundState();
}

class _InfiniteGridBackgroundState extends State<InfiniteGridBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    // 4 second loop smoothly completes one 40px cycle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    widget.mouseNotifier.addListener(_onMouseUpdate);
  }

  void _onMouseUpdate() {
    if (mounted) {
      setState(() {
        _mousePos = widget.mouseNotifier.value;
      });
    }
  }

  @override
  void dispose() {
    widget.mouseNotifier.removeListener(_onMouseUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: [
          // Base Ambient Orbs (Blurred elements)
          Positioned(
            right: -100,
            top: -100,
            child: _buildOrb(Colors.orange[800]!.withValues(alpha: 0.3), 400),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            top: -50,
            child: _buildOrb(Colors.purple[700]!.withValues(alpha: 0.2), 300),
          ),
          Positioned(
            left: -100,
            bottom: -200,
            child: _buildOrb(Colors.blue[800]!.withValues(alpha: 0.3), 500),
          ),

          // Layer 1: Very faint background infinite grid
          Opacity(
            opacity: 0.05,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _MovingGridPainter(offset: _controller.value * 40.0),
              ),
            ),
          ),

          // Layer 2: Mouse-tracking spotlight grid mask
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  return RadialGradient(
                    center: Alignment(
                      (_mousePos.dx - bounds.width / 2) / (bounds.width / 2) * 2,
                      (_mousePos.dy - bounds.height / 2) / (bounds.height / 2) * 2,
                    ),
                    radius: 400 / bounds.width, // roughly 400px radial glow
                    colors: const [Colors.black, Colors.transparent],
                    stops: const [0.0, 1.0],
                  ).createShader(bounds);
                },
                child: Opacity(
                  opacity: 0.4,
                  child: CustomPaint(
                    painter: _MovingGridPainter(offset: _controller.value * 40.0),
                  ),
                ),
              );
            },
          ),
        ],
      );
  }

  Widget _buildOrb(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _MovingGridPainter extends CustomPainter {
  final double offset;

  _MovingGridPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    const double step = 40.0;
    
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4) // Opacity controlled by parent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Shift bounds smoothly
    final shift = offset % step;

    // Vertical lines
    for (double x = shift - step; x <= size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal lines
    for (double y = shift - step; y <= size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MovingGridPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
