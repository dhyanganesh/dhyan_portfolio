import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class MenuOverlay extends StatefulWidget {
  final VoidCallback onClose;

  /// Called with the section key when a nav item is tapped.
  final void Function(String section) onNavigate;

  const MenuOverlay({
    super.key,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  State<MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<MenuOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  void _navigate(String section) {
    _ctrl.reverse().then((_) {
      widget.onClose();
      widget.onNavigate(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            border: Border(
              bottom: BorderSide(color: AppTheme.border, width: 1),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Subtle background accent — top-right glow
                Positioned(
                  top: -120,
                  right: -80,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.accentSalmon.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Close button — top left, matches nav bar layout
                Positioned(
                  top: 14,
                  left: 32,
                  child: _CloseButton(onTap: _close),
                ),

                // Center content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Monospace label
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 28),
                        child: Text(
                          '// navigate',
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.fgMuted,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      _NavItem(
                        label: 'Overview',
                        index: 0,
                        onTap: () => _navigate('hero'),
                      ),
                      _NavItem(
                        label: 'Hobbies',
                        index: 1,
                        onTap: () => _navigate('hobbies'),
                      ),
                      _NavItem(
                        label: 'Projects',
                        index: 2,
                        onTap: () => _navigate('projects'),
                      ),
                      _NavItem(
                        label: 'Work',
                        index: 3,
                        onTap: () => _navigate('work'),
                      ),
                      _NavItem(
                        label: 'Contact',
                        index: 4,
                        onTap: () => _navigate('contact'),
                      ),

                      const SizedBox(height: 40),

                      // Divider
                      SizedBox(
                        width: 320,
                        child: Divider(color: AppTheme.border, thickness: 1),
                      ),

                      const SizedBox(height: 24),

                      // Social / quick links row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QuickLink(
                            label: 'GitHub',
                            url: 'https://github.com/dhyanganesh',
                          ),
                          _Dot(),
                          _QuickLink(
                            label: 'LinkedIn',
                            url:
                                'https://www.linkedin.com/in/dhyan-ganesh-07b05525a/',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Close button ─────────────────────────────────────────────────────────────

class _CloseButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
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
            color: _hovered ? AppTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppTheme.border : Colors.transparent,
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            color: _hovered ? AppTheme.foreground : AppTheme.fgNav,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ── Nav item ─────────────────────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final String label;
  final int index;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.index,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 55), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Accent dash on hover
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _hovered ? 24 : 0,
                    height: 2,
                    margin: EdgeInsets.only(right: _hovered ? 12 : 0),
                    decoration: BoxDecoration(
                      color: AppTheme.accentSalmon,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: GoogleFonts.spaceMono(
                      color: _hovered ? AppTheme.foreground : AppTheme.fgNav,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      height: 1.15,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick link ────────────────────────────────────────────────────────────────

class _QuickLink extends StatefulWidget {
  final String label;
  final String? url;
  const _QuickLink({required this.label, this.url});

  @override
  State<_QuickLink> createState() => _QuickLinkState();
}

class _QuickLinkState extends State<_QuickLink> {
  bool _hovered = false;

  Future<void> _launch() async {
    if (widget.url == null) return;
    final uri = Uri.parse(widget.url!);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.url != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.spaceMono(
            color: _hovered ? AppTheme.foreground : AppTheme.fgMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: AppTheme.border,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
