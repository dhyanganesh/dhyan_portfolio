import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/text_scramble.dart';
import '../widgets/flipping_card.dart';

class HobbiesSection extends StatelessWidget {
  const HobbiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final hPad = isDesktop ? 40.0 : 20.0;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Hobbies.'),
          const SizedBox(height: 48),
          const _HorizontalCardList(),
        ],
      ),
    );
  }
}

// ── Horizontal scroll list ────────────────────────────────────────────────────

class _HorizontalCardList extends StatelessWidget {
  const _HorizontalCardList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemCount: _hobbies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => _HobbyCard(hobby: _hobbies[i]),
      ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _HobbyCard extends StatelessWidget {
  final _HobbyData hobby;
  const _HobbyCard({required this.hobby});

  @override
  Widget build(BuildContext context) {
    return FlippingCard(
      width: 260,
      height: 320,
      frontDecoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      backDecoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      frontContent: _FrontFace(hobby: hobby),
      backContent: _BackFace(hobby: hobby),
    );
  }
}

// ── Front face: image + title ─────────────────────────────────────────────────

class _FrontFace extends StatelessWidget {
  final _HobbyData hobby;
  const _FrontFace({required this.hobby});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image — top ~60% of card
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            child: Image.network(
              hobby.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppTheme.cardDark,
                child: const Center(
                  child: Icon(Icons.image_not_supported_rounded,
                      color: AppTheme.border, size: 28),
                ),
              ),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppTheme.cardDark,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppTheme.fgMuted,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Title + hint — bottom ~40%
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hobby.title,
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.foreground,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'hover to flip',
                      style: GoogleFonts.spaceMono(
                        color: AppTheme.fgMuted,
                        fontSize: 10,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.flip_rounded,
                        color: AppTheme.fgMuted, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Back face: description ────────────────────────────────────────────────────

class _BackFace extends StatelessWidget {
  final _HobbyData hobby;
  const _BackFace({required this.hobby});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hobby.title,
            style: GoogleFonts.spaceMono(
              color: AppTheme.foreground,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.accentSalmon,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hobby.description,
            style: GoogleFonts.spaceMono(
              color: AppTheme.fgNav,
              fontSize: 12,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

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

// ── Data ──────────────────────────────────────────────────────────────────────

class _HobbyData {
  final String title;
  final String imageUrl;
  final String description;

  const _HobbyData({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

const List<_HobbyData> _hobbies = [
  _HobbyData(
    title: 'Photography',
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=800&q=80',
    description:
        'Capturing moments and framing the world through different lenses.',
  ),
  _HobbyData(
    title: 'Reading',
    imageUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=800&q=80',
    description:
        'Diving deep into fiction, biographies, and tech articles.',
  ),
  _HobbyData(
    title: 'Music',
    imageUrl:
        'https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=800&q=80',
    description:
        'Strumming chords and finding rhythm and peace outside of code.',
  ),
  _HobbyData(
    title: 'Traveling',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=800&q=80',
    description:
        'Exploring new cultures, architectures, and landscapes.',
  ),
  _HobbyData(
    title: 'Gaming',
    imageUrl:
        'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?auto=format&fit=crop&w=800&q=80',
    description:
        'Immersing in interactive stories and competitive play.',
  ),
];
