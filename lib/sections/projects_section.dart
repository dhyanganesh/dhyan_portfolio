import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bento_grid.dart';
import '../widgets/text_scramble.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
          _SectionTitle(title: 'Projects.'),
          const SizedBox(height: 40),
          const BentoGrid(),
        ],
      ),
    );
  }
}

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
