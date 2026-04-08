import 'package:flutter/material.dart';

class BentoCard extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.height,
    this.borderRadius,
    this.onTap,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: widget.height,
          transform: Matrix4.identity()
            ..translate(0.0, _hovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF3A3A4A)
                  : const Color(0xFF252530),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(18),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
