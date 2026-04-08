import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onMenuTap;

  const NavBar(
      {super.key, required this.scrollController, required this.onMenuTap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = widget.scrollController.offset > 50;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _scrolled ? 14 : 0,
            sigmaY: _scrolled ? 14 : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _scrolled
                  ? AppTheme.background.withValues(alpha: 0.88)
                  : Colors.transparent,
              border: _scrolled
                  ? const Border(
                      bottom: BorderSide(color: AppTheme.border, width: 1))
                  : null,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Text(
                  'Dhyan.',
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),

                // Hamburger button
                _HamburgerButton(onTap: widget.onMenuTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HamburgerButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HamburgerButton({required this.onTap});

  @override
  State<_HamburgerButton> createState() => _HamburgerButtonState();
}

class _HamburgerButtonState extends State<_HamburgerButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Bar(wide: true, hovered: _hovered),
              const SizedBox(height: 5),
              _Bar(wide: false, hovered: _hovered),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final bool wide;
  final bool hovered;
  const _Bar({required this.wide, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: wide ? 20 : 13,
      height: 1.5,
      decoration: BoxDecoration(
        color: hovered ? AppTheme.foreground : AppTheme.fgNav,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
