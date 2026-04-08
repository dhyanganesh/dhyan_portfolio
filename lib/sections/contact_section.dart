import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/text_scramble.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final hPad = isDesktop ? 40.0 : 20.0;

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextScramble(
            text: 'Contact.',
            duration: const Duration(milliseconds: 1200),
            style: GoogleFonts.spaceMono(
              color: AppTheme.foreground,
              fontSize: isDesktop ? 80 : 52,
              fontWeight: FontWeight.w900,
              letterSpacing: -3,
              height: 1,
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: const _ContactCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: isDesktop
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left side info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: _buildLeftContent(isDesktop: true),
                        ),
                      ),
                      // Right side form
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withOpacity(0.3),
                            border: const Border(
                              left: BorderSide(color: AppTheme.border),
                            ),
                          ),
                          padding: const EdgeInsets.all(32.0),
                          child: const _ContactForm(),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left side info
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildLeftContent(isDesktop: false),
                    ),
                    // Right side form
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.3),
                        border: const Border(
                          top: BorderSide(color: AppTheme.border),
                        ),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: const _ContactForm(),
                    ),
                  ],
                ),
        ),
        // Plus Icons in Corners
        const Positioned(top: -12, left: -12, child: _PlusIcon()),
        const Positioned(top: -12, right: -12, child: _PlusIcon()),
        const Positioned(bottom: -12, left: -12, child: _PlusIcon()),
        const Positioned(bottom: -12, right: -12, child: _PlusIcon()),
      ],
    );
  }

  Widget _buildLeftContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in touch',
              style: GoogleFonts.spaceMono(
                color: AppTheme.foreground,
                fontSize: isDesktop ? 42 : 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'If you have any questions regarding my services or need help, please fill out the form here. I do my best to respond within 1 business day.',
              style: GoogleFonts.spaceMono(
                color: AppTheme.fgMuted,
                fontSize: isDesktop ? 16 : 14,
                height: 1.6,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 48 : 32),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: const [
            _ContactInfo(
              icon: LucideIcons.mail,
              label: 'Email',
              value: 'dhyanganesh@gmail.com',
            ),
            _ContactInfo(
              icon: LucideIcons.phone,
              label: 'Phone',
              value: '+91 9380351931',
            ),
            _ContactInfo(
              icon: LucideIcons.mapPin,
              label: 'Address',
              value: 'Bengaluru, Karnataka',
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border.withOpacity(0.5)),
          ),
          child: Icon(icon, color: AppTheme.foreground, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: AppTheme.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: AppTheme.fgMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FormInput(label: 'Name'),
        const SizedBox(height: 16),
        _FormInput(label: 'Email'),
        const SizedBox(height: 16),
        _FormInput(label: 'Message', isTextArea: true),
        const SizedBox(height: 24),
        _SubmitButton(),
      ],
    );
  }
}

class _FormInput extends StatelessWidget {
  final String label;
  final bool isTextArea;

  const _FormInput({required this.label, this.isTextArea = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            color: AppTheme.foreground,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: isTextArea ? 100 : 44,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: isTextArea
              ? TextFormField(
                  maxLines: null,
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.foreground,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              : TextFormField(
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.foreground,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  static const List<String> _funnyMessages = [
    "📭  Delivered to /dev/null — it's in great company.",
    "🚧  Backend under construction. Try again in... 2027?",
    "🤷  The server is me, and I'm asleep right now.",
    "🏖️  Backend dev (also me) is on vacation. Indefinitely.",
    "404: Inbox not found. Carrier pigeon is more reliable.",
  ];

  void _onSubmit(BuildContext context) {
    final msg = ([..._funnyMessages]..shuffle()).first;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.border),
        ),
        duration: const Duration(seconds: 4),
        content: Text(
          msg,
          style: GoogleFonts.spaceMono(
            color: AppTheme.fgNav,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onSubmit(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            'Submit',
            style: GoogleFonts.spaceMono(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlusIcon extends StatelessWidget {
  const _PlusIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Icon(
        LucideIcons.plus,
        color: AppTheme.fgMuted.withOpacity(0.5),
        size: 24,
      ),
    );
  }
}
