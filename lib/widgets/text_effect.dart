import 'dart:ui';
import 'package:flutter/material.dart';

enum TextEffectPreset { blur, shake, scale, fade, slide }
enum TextEffectPer { word, char, line }

class TextEffect extends StatefulWidget {
  final String text;
  final TextEffectPer per;
  final TextEffectPreset preset;
  final TextStyle? style;
  final Duration delay;
  final Duration duration;
  final double staggerDelay;

  const TextEffect({
    super.key,
    required this.text,
    this.per = TextEffectPer.char,
    this.preset = TextEffectPreset.slide,
    this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.staggerDelay = 0.05,
  });

  @override
  State<TextEffect> createState() => _TextEffectState();
}

class _TextEffectState extends State<TextEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<String> _segments = [];

  @override
  void initState() {
    super.initState();
    _parseSegments();
    _controller = AnimationController(
        vsync: this, duration: _calculateTotalDuration());

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  void _parseSegments() {
    if (widget.per == TextEffectPer.line) {
      _segments = widget.text.split('\n');
    } else if (widget.per == TextEffectPer.word) {
      final words = widget.text.split(' ');
      _segments = [];
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          _segments.add(words[i]);
        }
        if (i < words.length - 1) {
          _segments.add(' ');
        }
      }
    } else {
      _segments = widget.text.split('');
    }
  }

  Duration _calculateTotalDuration() {
    // Only stagger non-space characters
    final nonSpaceCount = _segments.where((s) => s.trim().length > 0).length;
    final double totalMs = widget.duration.inMilliseconds + (nonSpaceCount * widget.staggerDelay * 1000);
    return Duration(milliseconds: totalMs.toInt());
  }

  @override
  void didUpdateWidget(TextEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text || 
        widget.per != oldWidget.per || 
        widget.preset != oldWidget.preset ||
        widget.staggerDelay != oldWidget.staggerDelay) {
      _parseSegments();
      _controller.duration = _calculateTotalDuration();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap is good for char/word. For line, Column is better.
    if (widget.per == TextEffectPer.line) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      );
    } else {
      return Wrap(
        children: _buildChildren(),
      );
    }
  }

  List<Widget> _buildChildren() {
    int staggerIndex = 0;
    return List.generate(_segments.length, (index) {
      bool isSpace = _segments[index] == ' ' || _segments[index] == '\n';
      
      if (isSpace) {
        // Just return the spacing normally
        return Text(_segments[index], style: widget.style);
      }

      final widgetSegment = _buildSegment(index, staggerIndex);
      staggerIndex++;
      return widgetSegment;
    });
  }

  Widget _buildSegment(int listIndex, int staggerIndex) {
    final double segmentDurationRatio = widget.duration.inMilliseconds / _controller.duration!.inMilliseconds;
    final double staggerRatio = (widget.staggerDelay * 1000) / _controller.duration!.inMilliseconds;

    final double startTime = staggerIndex * staggerRatio;
    double endTime = startTime + segmentDurationRatio;
    if (endTime > 1.0) endTime = 1.0;

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
    );

    final childWidget = Text(_segments[listIndex], style: widget.style);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final val = animation.value;

        switch (widget.preset) {
          case TextEffectPreset.blur:
            final sigma = 12.0 * (1 - val);
            return Opacity(
              opacity: val,
              child: sigma > 0.01
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                      child: child,
                    )
                  : child,
            );
          case TextEffectPreset.slide:
            return Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 20.0 * (1 - val)),
                child: child,
              ),
            );
          case TextEffectPreset.scale:
            return Opacity(
              opacity: val,
              child: Transform.scale(
                scale: val,
                child: child,
              ),
            );
          case TextEffectPreset.shake:
            double shX = 0;
            if (val < 0.25) {
              shX = -5 * (val / 0.25);
            } else if (val < 0.5) {
              shX = -5 + 10 * ((val - 0.25) / 0.25);
            } else if (val < 0.75) {
              shX = 5 - 10 * ((val - 0.5) / 0.25);
            } else {
              shX = -5 + 5 * ((val - 0.75) / 0.25);
            }
            return Transform.translate(
              offset: Offset(shX, 0),
              child: child,
            );
          case TextEffectPreset.fade:
            return Opacity(
              opacity: val,
              child: child,
            );
        }
      },
      child: childWidget,
    );
  }
}
