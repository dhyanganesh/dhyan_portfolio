import 'dart:math';
import 'package:flutter/material.dart';

class TextScramble extends StatefulWidget {
  final String text;
  final Duration duration;
  final String characterSet;
  final TextStyle? style;
  final bool trigger;
  final VoidCallback? onScrambleComplete;

  const TextScramble({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 1000),
    this.characterSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
    this.style,
    this.trigger = true,
    this.onScrambleComplete,
  });

  @override
  State<TextScramble> createState() => _TextScrambleState();
}

class _TextScrambleState extends State<TextScramble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _displayText = '';
  String _initialScrambled = '';
  final Random _random = Random();
  bool _triggered = false;

  ScrollPosition? _scrollPosition;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: widget.duration,
    );
    _initialScrambled = _generateScrambled(0.0);
    _displayText = _initialScrambled;

    _controller.addListener(() {
      setState(() {
        _displayText = _generateScrambled(_controller.value);
      });
    });

    _controller.addStatusListener((status) {
       if (status == AnimationStatus.completed) {
         widget.onScrambleComplete?.call();
       }
    });
  }

  String _generateScrambled(double progress) {
    String scrambled = '';
    for (int i = 0; i < widget.text.length; i++) {
       if (widget.text[i] == ' ') {
         scrambled += ' ';
         continue;
       }
       if (progress * widget.text.length > i) {
         scrambled += widget.text[i];
       } else {
         scrambled += widget.characterSet[_random.nextInt(widget.characterSet.length)];
       }
    }
    return scrambled;
  }

  void _checkScroll() {
    if (_triggered || !mounted) return;
    
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    
    // Trigger if it enters the bottom 95% of screen
    if (pos.dy < screenH * 0.95 && pos.dy > -box.size.height) {
      _triggered = true;
      _scrollPosition?.removeListener(_checkScroll);
      if (widget.trigger) {
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_checkScroll);
    try {
      _scrollPosition = Scrollable.of(context).position;
      _scrollPosition!.addListener(_checkScroll);
    } catch (_) {}
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScroll());
  }

  @override
  void didUpdateWidget(TextScramble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _triggered = false; 
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkScroll());
    } else if (widget.text != oldWidget.text && !_controller.isAnimating) {
      _displayText = widget.text;
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      key: _key,
      _displayText,
      style: widget.style,
    );
  }
}
