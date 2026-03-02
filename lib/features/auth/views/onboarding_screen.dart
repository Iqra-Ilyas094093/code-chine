import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Team work all',
      description:
      'Collaborate with your team seamlessly, manage projects and achieve goals together.',
      illustration: _TeamIllustration(),
    ),
    _OnboardingData(
      title: 'Track Progress',
      description:
      'Monitor your milestones, keep track of deadlines, and celebrate achievements.',
      illustration: _ProgressIllustration(),
    ),
    _OnboardingData(
      title: 'Stay Connected',
      description:
      'Real-time communication with your team members across all devices.',
      illustration: _ConnectIllustration(),
    ),
    _OnboardingData(
      title: 'Grow Together',
      description:
      'Build stronger teams, foster innovation and scale your business with confidence.',
      illustration: _GrowIllustration(),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => vm.setOnboardingPage(i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.75,
                        height: size.width * 0.65,
                        decoration: BoxDecoration(
                          color: AppColors.onboardingBg,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: page.illustration,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final isActive = i == vm.currentOnboardingPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Expanded(
                    child: _BlackButton(
                      text: 'Sign in',
                      onPressed: () => vm.goToScreen(AuthScreen.signIn),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Register',
                      onPressed: () => vm.goToScreen(AuthScreen.register),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BlackButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _BlackButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final Widget illustration;
  _OnboardingData(
      {required this.title,
        required this.description,
        required this.illustration});
}

// ── Illustrations ──────────────────────────────────────────

class _TeamIllustration extends StatelessWidget {
  const _TeamIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TeamPainter(),
      child: Container(),
    );
  }
}

class _TeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background circle
    final bgCircle = Paint()
      ..color = const Color(0xFFDDDDFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + 10), size.width * 0.3, bgCircle);

    // Poles
    final polePaint = Paint()
      ..color = const Color(0xFF333355)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final checkPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final x = cx - 30 + i * 30.0;
      canvas.drawLine(Offset(x, cy - 20), Offset(x, cy + 40), polePaint);
      canvas.drawCircle(Offset(x, cy - 25), 12, checkPaint);
      final checkMark = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final path = Path()
        ..moveTo(x - 5, cy - 25)
        ..lineTo(x - 1, cy - 21)
        ..lineTo(x + 6, cy - 31);
      canvas.drawPath(path, checkMark);
    }

    _drawPerson(canvas, Offset(cx - 65, cy), AppColors.primary, false);
    _drawPerson(canvas, Offset(cx + 65, cy), const Color(0xFF333355), true);
  }

  void _drawPerson(Canvas canvas, Offset pos, Color color, bool flip) {
    final bodyPaint = Paint()..color = color;
    final skinPaint = Paint()..color = const Color(0xFFFFCBA4);
    final pantsPaint = Paint()..color = const Color(0xFF2D2D4E);

    canvas.drawCircle(Offset(pos.dx, pos.dy - 55), 16, skinPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(pos.dx, pos.dy - 15), width: 30, height: 38),
          const Radius.circular(6),
        ),
        bodyPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(pos.dx - 14, pos.dy + 8, 12, 30),
            const Radius.circular(4)),
        pantsPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(pos.dx + 2, pos.dy + 8, 12, 30),
            const Radius.circular(4)),
        pantsPaint);
    final armPaint = Paint()
      ..color = skinPaint.color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(flip ? pos.dx - 10 : pos.dx + 10, pos.dy - 20),
        Offset(flip ? pos.dx - 20 : pos.dx + 20, pos.dy - 5),
        armPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressIllustration extends StatelessWidget {
  const _ProgressIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.trending_up_rounded,
              size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bar(0.4, AppColors.primary),
              const SizedBox(width: 8),
              _bar(0.7, const Color(0xFF9B92FF)),
              const SizedBox(width: 8),
              _bar(0.55, AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(double fill, Color color) {
    return Container(
      width: 32,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: fill,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _ConnectIllustration extends StatelessWidget {
  const _ConnectIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.15),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child:
            const Icon(Icons.wifi_rounded, color: Colors.white, size: 30),
          ),
          ...[
            const Offset(-70, -30),
            const Offset(70, -30),
            const Offset(-50, 55),
            const Offset(50, 55),
          ].map(
                (offset) => Positioned(
              left: 130 / 2 + offset.dx - 18,
              top: 130 / 2 + offset.dy - 18,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF9B92FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child:
                const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowIllustration extends StatelessWidget {
  const _GrowIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              const Icon(Icons.rocket_launch_rounded,
                  size: 60, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip('32%', 'Growth'),
              const SizedBox(width: 12),
              _chip('4.9★', 'Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          Text(label,
              style:
              GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}