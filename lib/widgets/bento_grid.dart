import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BentoItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String? status;
  final List<String>? tags;
  final String? meta;
  final String? cta;
  final String? githubUrl;
  final int colSpan;
  final bool hasPersistentHover;

  const BentoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.status,
    this.tags,
    this.meta,
    this.cta,
    this.githubUrl,
    this.colSpan = 1,
    this.hasPersistentHover = false,
  });
}

const List<BentoItem> itemsSample = [
  BentoItem(
    title: 'Car Rental Booking',
    meta: 'Django',
    description:
        'Full-stack car rental platform with booking management and payment gateway integration. Built as a college demo project.',
    icon: LucideIcons.car,
    iconColor: AppTheme.accentTeal,
    status: 'Demo',
    tags: ['Django', 'Python', 'Payments'],
    cta: 'View on GitHub →',
    githubUrl: 'https://github.com/dhyanganesh/carbooking-master',
    colSpan: 2,
    hasPersistentHover: true,
  ),
  BentoItem(
    title: 'To-Do List',
    meta: 'Django',
    description:
        'Hands-on Django app with user authentication and full CRUD operations. Built to solidify backend fundamentals.',
    icon: LucideIcons.checkSquare,
    iconColor: AppTheme.accentGreen,
    status: 'Learning',
    tags: ['Django', 'Python', 'Auth', 'CRUD'],
    cta: 'View on GitHub →',
    githubUrl: 'https://github.com/dhyanganesh/to-do-list-1',
  ),
  BentoItem(
    title: 'Movie Predictor',
    meta: 'ML + Flutter',
    description:
        'Flutter UI that takes user inputs and returns a recommended movie from a Random Forest model trained on a large movie dataset. Two-repo system — Flutter frontend talks to the Python ML backend.',
    icon: LucideIcons.film,
    iconColor: AppTheme.accentSalmon,
    status: 'ML Project',
    tags: ['Flutter', 'Python', 'ML', 'Random Forest'],
    cta: 'View UI →',
    githubUrl: 'https://github.com/dhyanganesh/movie_predictor_ui',
    colSpan: 2,
  ),
  BentoItem(
    title: 'This Portfolio',
    meta: 'Flutter Web',
    description:
        'The site you\'re on right now. A fully animated, dark-mode Flutter Web portfolio with scroll-driven reveals, flip cards, and a custom grid background.',
    icon: LucideIcons.globe,
    iconColor: AppTheme.accentBlue,
    status: 'You\'re here',
    tags: ['Flutter', 'Web', 'Animations'],
    cta: 'View on GitHub →',
    githubUrl: 'https://github.com/dhyanganesh/dhyan_portfolio',
    hasPersistentHover: false,
  ),
];

class BentoGrid extends StatelessWidget {
  final List<BentoItem> items;

  const BentoGrid({super.key, this.items = itemsSample});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 768 ? 1 : 3;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: StaggeredGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: items.map((item) {
              int itemColSpan =
                  crossAxisCount == 1 ? 1 : item.colSpan.clamp(1, crossAxisCount);
              return StaggeredGridTile.fit(
                crossAxisCellCount: itemColSpan,
                child: _BentoCard(item: item),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _BentoCard extends StatefulWidget {
  final BentoItem item;
  const _BentoCard({required this.item});

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _isHovered = false;

  Future<void> _openUrl() async {
    final url = widget.item.githubUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final bool showHover = widget.item.hasPersistentHover || _isHovered;
    final bool hasLink = widget.item.githubUrl != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          hasLink ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: hasLink ? _openUrl : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, showHover ? -3.0 : 0.0),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: showHover
                  ? widget.item.iconColor.withValues(alpha: 0.35)
                  : AppTheme.border,
            ),
            boxShadow: showHover
                ? [
                    BoxShadow(
                      color: widget.item.iconColor.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Subtle radial glow on hover
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: showHover ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: RadialGradient(
                      colors: [
                        widget.item.iconColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      radius: 1.5,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon row + status badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: widget.item.iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(widget.item.icon,
                              color: widget.item.iconColor, size: 18),
                        ),
                        if (widget.item.status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.border,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.item.status!,
                              style: GoogleFonts.spaceMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.fgNav,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title + meta
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.title,
                            style: GoogleFonts.spaceMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.foreground,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        if (widget.item.meta != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            widget.item.meta!,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              color: AppTheme.fgMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      widget.item.description,
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        color: AppTheme.fgNav,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tags + CTA
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: (widget.item.tags ?? []).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.border,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 10,
                                    color: AppTheme.fgMuted,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: showHover ? 1.0 : 0.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.item.cta ?? 'Explore →',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: widget.item.iconColor,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
