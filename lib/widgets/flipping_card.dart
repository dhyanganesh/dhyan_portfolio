import 'dart:math';
import 'package:flutter/material.dart';

class FlippingCard extends StatefulWidget {
  final Widget frontContent;
  final Widget backContent;
  final double width;
  final double height;
  final BoxDecoration? frontDecoration;
  final BoxDecoration? backDecoration;

  const FlippingCard({
    super.key,
    required this.frontContent,
    required this.backContent,
    this.width = 350,
    this.height = 300,
    this.frontDecoration,
    this.backDecoration,
  });

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          if (_controller.isCompleted)
            _controller.reverse();
          else
            _controller.forward();
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value;
            final isBack = angle > pi / 2;

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isBack
                  ? Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: _buildFace(isBack: true),
                    )
                  : _buildFace(isBack: false),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFace({required bool isBack}) {
    // We add the parallax "translateZ" inside the container
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: isBack ? widget.backDecoration : widget.frontDecoration,
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Transform(
          // Parallax 3D Pop-out effect
          transform: Matrix4.identity()
            ..translate(0.0, 0.0, 50.0)
            ..scale(0.93),
          alignment: Alignment.center,
          child: isBack ? widget.backContent : widget.frontContent,
        ),
      ),
    );
  }
}
