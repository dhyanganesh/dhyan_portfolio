import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/grid_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/text_scramble.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final hPad = isDesktop ? 40.0 : 20.0;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Work.'),
          const SizedBox(height: 40),
          if (isDesktop) _DesktopWorkGrid() else _MobileWorkGrid(),
          const SizedBox(height: 60),
          _ContactTeaser(),
        ],
      ),
    );
  }
}

class _DesktopWorkGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const jobs = _workItems;
    return Column(
      children: [
        RevealOnScroll(child: _WorkCard(job: jobs[0], fullWidth: true)),
        const SizedBox(height: 12),
        RevealOnScroll(
          delay: const Duration(milliseconds: 80),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _WorkCard(job: jobs[1])),
                const SizedBox(width: 12),
                Expanded(child: _WorkCard(job: jobs[2])),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileWorkGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _workItems
          .map(
            (j) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WorkCard(job: j),
            ),
          )
          .toList(),
    );
  }
}

class _WorkCard extends StatelessWidget {
  final _WorkItem job;
  final bool fullWidth;
  const _WorkCard({required this.job, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return GridCard(
      height: fullWidth ? 240.0 : 280.0,
      padding: const EdgeInsets.all(28),
      child: fullWidth
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _YearBadge(year: job.year),
                      const SizedBox(height: 14),
                      Text(
                        job.company,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.foreground,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        job.role,
                        style: GoogleFonts.spaceMono(
                          color: job.accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        job.description,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.fgNav,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: job.iconBgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(job.icon, color: job.accentColor, size: 32),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _YearBadge(year: job.year),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: job.iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(job.icon, color: job.accentColor, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  job.company,
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.foreground,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job.role,
                  style: GoogleFonts.spaceMono(
                    color: job.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    job.description,
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.fgNav,
                      fontSize: 13,
                      height: 1.6,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
    );
  }
}

class _YearBadge extends StatelessWidget {
  final String year;
  const _YearBadge({required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF252530),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        year,
        style: GoogleFonts.spaceMono(color: AppTheme.fgMuted, fontSize: 11),
      ),
    );
  }
}

class _ContactTeaser extends StatefulWidget {
  @override
  State<_ContactTeaser> createState() => _ContactTeaserState();
}

class _ContactTeaserState extends State<_ContactTeaser> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I write about design, Flutter, and the web.',
          style: GoogleFonts.spaceMono(
            color: AppTheme.fgMuted,
            fontSize: isDesktop ? 16 : 14,
            height: 1.9,
          ),
        ),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: GoogleFonts.spaceMono(
                  color: _hovered ? AppTheme.foreground : AppTheme.fgNav,
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  height: 1.9,
                ),
                child: const Text('Get in touch'),
              ),
              const SizedBox(width: 6),
              AnimatedSlide(
                duration: const Duration(milliseconds: 150),
                offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                child: Icon(
                  Icons.arrow_forward,
                  color: _hovered ? AppTheme.foreground : AppTheme.fgNav,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkItem {
  final String company;
  final String role;
  final String description;
  final String year;
  final Color bgColor;
  final Color iconBgColor;
  final Color accentColor;
  final IconData icon;
  final bool showGradient;
  final List<Color> gradientColors;

  const _WorkItem({
    required this.company,
    required this.role,
    required this.description,
    required this.year,
    required this.bgColor,
    required this.iconBgColor,
    required this.accentColor,
    required this.icon,
    this.showGradient = false,
    this.gradientColors = const [],
  });
}

const List<_WorkItem> _workItems = [
  _WorkItem(
    company: 'LG Soft India',
    role: 'Research Engineer II',
    description:
        'Built an in-house custom UI package for ad components rendered in the Home App. Migrated a React IoT UI interface to Flutter with performance optimization and a measurably reduced startup load.',
    year: 'Mar 2025 – Present',
    bgColor: Color(0xFF0A0F18),
    iconBgColor: Color(0xFF141C2A),
    accentColor: AppTheme.accentTeal,
    icon: Icons.rocket_launch_rounded,
    showGradient: true,
    gradientColors: [Color(0xFF0A2A2A), Color(0xFF0A0F18), Color(0xFF0A0F18)],
  ),
  _WorkItem(
    company: 'LG Soft India',
    role: 'Research Engineer I',
    description:
        'Owned Flutter app development across multiple products — took over tvHotkey, migrated the Welcome Video app, and shipped a fully responsive GUI redesign.',
    year: 'May 2024 – Mar 2025',
    bgColor: Color(0xFF0E0A1A),
    iconBgColor: Color(0xFF1A1228),
    accentColor: AppTheme.accentPurple,
    icon: Icons.phone_android_rounded,
  ),
  _WorkItem(
    company: 'LG Soft India',
    role: 'Research Engineer Intern',
    description:
        'Contributed to the core Home App for webOS TVs — built ad banner components, shipped system features, and resolved critical bugs across SystemUI and auxiliary services.',
    year: 'Nov 2023 – May 2024',
    bgColor: Color(0xFF0A1A10),
    iconBgColor: Color(0xFF122018),
    accentColor: AppTheme.accentGreen,
    icon: Icons.tv_rounded,
  ),
];

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    return TextScramble(
      text: title,
      duration: const Duration(milliseconds: 1200),
      style: GoogleFonts.spaceMono(
        color: AppTheme.foreground,
        fontSize: isDesktop ? 80 : 52,
        fontWeight: FontWeight.w900,
        letterSpacing: -3,
        height: 1,
      ),
    );
  }
}
