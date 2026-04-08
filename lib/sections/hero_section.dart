import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/text_effect.dart';

class HeroSection extends StatefulWidget {
  final ScrollController? scrollController;
  const HeroSection({super.key, this.scrollController});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.7, curve: Curves.easeOut)),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.7, curve: Curves.easeOutCubic)));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final nameFontSize = isDesktop ? size.width * 0.09 : size.width * 0.12;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          width: double.infinity,
          height: size.height,
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // "Dhyan" — top left, huge
              Positioned(
                top: size.height * 0.14,
                left: isDesktop ? 40 : 20,
                child: TextEffect(
                  text: 'Dhyan',
                  per: TextEffectPer.char,
                  preset: TextEffectPreset.slide,
                  duration: const Duration(milliseconds: 600),
                  staggerDelay: 0.08,
                  delay: const Duration(milliseconds: 1400),
                  style: GoogleFonts.spaceMono(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.foreground,
                    letterSpacing: -nameFontSize * 0.04,
                    height: 0.9,
                  ),
                ),
              ),

              // Geometric logo — centered with glow
              Center(
                child: Container(
                  width: isDesktop ? 320 : 220,
                  height: isDesktop ? 320 : 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentSalmon.withValues(alpha: 0.12),
                        blurRadius: 80,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: _GeometricLogoPainter(
                      strokeColor: AppTheme.accentSalmon,
                    ),
                  ),
                ),
              ),

              // Last name / role — bottom right, huge
              Positioned(
                bottom: size.height * 0.18,
                right: isDesktop ? 40 : 20,
                child: TextEffect(
                  text: 'Portfolio',
                  per: TextEffectPer.char,
                  preset: TextEffectPreset.slide,
                  duration: const Duration(milliseconds: 600),
                  staggerDelay: 0.08,
                  delay: const Duration(milliseconds: 1550),
                  style: GoogleFonts.spaceMono(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.foreground,
                    letterSpacing: -nameFontSize * 0.04,
                    height: 0.9,
                  ),
                ),
              ),

              // Tagline — center bottom area
              Positioned(
                bottom: size.height * 0.08,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'design, code, & build.',
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.fgNav,
                      fontSize: isDesktop ? 14 : 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // Scroll indicator
              Positioned(
                bottom: size.height * 0.04,
                left: 0,
                right: 0,
                child: Center(
                  child: _ScrollIndicator(
                    onTap: () {
                      widget.scrollController?.animateTo(
                        size.height,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeometricLogoPainter extends CustomPainter {
  final Color strokeColor;
  const _GeometricLogoPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (int i = 0; i < 7; i++) {
      final t = i / 6.0;
      final scale = 1.0 - t * 0.72;
      final opacity = 0.25 + t * 0.75;

      final paint = Paint()
        ..color = strokeColor.withValues(alpha: opacity)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final h = size.height * 0.46 * scale;
      final w = size.width * 0.44 * scale;

      final top = Offset(cx, cy - h);
      final bl = Offset(cx - w, cy + h * 0.72);
      final br = Offset(cx + w, cy + h * 0.72);

      final path = Path()
        ..moveTo(top.dx, top.dy)
        ..lineTo(bl.dx, bl.dy)
        ..lineTo(br.dx, br.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class _ScrollIndicator extends StatefulWidget {
  final VoidCallback? onTap;
  const _ScrollIndicator({this.onTap});

  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Opacity(
            opacity: 0.3 + _anim.value * 0.5,
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.fgNav,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
