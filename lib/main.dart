import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'sections/hero_section.dart';
import 'sections/hobbies_section.dart';
import 'sections/projects_section.dart';
import 'sections/work_section.dart';
import 'sections/contact_section.dart';
import 'widgets/nav_bar.dart';
import 'widgets/menu_overlay.dart';
import 'widgets/infinite_grid_background.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhyan — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<Offset> _mouseNotifier = ValueNotifier(Offset.zero);
  bool _menuOpen = false;

  // Section keys for deep-link scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _hobbiesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    _mouseNotifier.dispose();
    super.dispose();
  }

  // Nav bar is ~70px tall; add a small extra gap for breathing room.
  static const double _navBarHeight = 80.0;

  void _scrollToSection(String section) {
    final key = switch (section) {
      'hero' => _heroKey,
      'hobbies' => _hobbiesKey,
      'projects' => _projectsKey,
      'work' => _workKey,
      'contact' => _contactKey,
      _ => _heroKey,
    };

    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    // dy relative to the current viewport top
    final dy = box.localToGlobal(Offset.zero).dy;
    // Convert to absolute scroll position and subtract nav bar height
    final target = (_scrollController.offset + dy - _navBarHeight)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        onHover: (event) => _mouseNotifier.value = event.localPosition,
        child: Stack(
          children: [
            Positioned.fill(
              child: InfiniteGridBackground(mouseNotifier: _mouseNotifier),
            ),

            // Main scroll content
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeyedSubtree(
                    key: _heroKey,
                    child: HeroSection(scrollController: _scrollController),
                  ),
                  KeyedSubtree(
                    key: _hobbiesKey,
                    child: const HobbiesSection(),
                  ),
                  KeyedSubtree(
                    key: _projectsKey,
                    child: const ProjectsSection(),
                  ),
                  KeyedSubtree(
                    key: _workKey,
                    child: const WorkSection(),
                  ),
                  KeyedSubtree(
                    key: _contactKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        ContactSection(),
                        _FooterSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nav bar
            NavBar(
              scrollController: _scrollController,
              onMenuTap: () => setState(() => _menuOpen = true),
            ),

            // Full-screen menu overlay
            if (_menuOpen)
              Positioned.fill(
                child: MenuOverlay(
                  onClose: () => setState(() => _menuOpen = false),
                  onNavigate: _scrollToSection,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
          isDesktop ? 40 : 20, 40, isDesktop ? 40 : 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppTheme.border, thickness: 1),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dhyan.',
                style: GoogleFonts.spaceMono(
                  color: AppTheme.foreground,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '© 2026 · Built with Flutter',
                style: GoogleFonts.spaceMono(
                  color: AppTheme.fgMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
