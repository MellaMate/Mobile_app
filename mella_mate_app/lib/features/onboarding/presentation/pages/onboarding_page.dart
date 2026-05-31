import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/auth/presentation/pages/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const brandGreen = Color(0xFF0FA71A);

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Pioneer Crypto Gateway',
      description: 'The first ever payment gateway built on crypto infrastructure in Ethiopia and Kenya.',
      icon: Icons.rocket_launch,
    ),
    OnboardingItem(
      title: 'Lightning Fast Settlements',
      description: 'Say goodbye to waiting. Experience instant settlements and real-time transaction tracking.',
      icon: Icons.flash_on,
    ),
    OnboardingItem(
      title: 'Bank-Grade Security',
      description: 'Full compliance and end-to-end encryption for every transaction you make.',
      icon: Icons.security,
    ),
    OnboardingItem(
      title: 'Global Reach, Local Power',
      description: 'Connect with M-Pesa natively and serve customers across East Africa instantly.',
      icon: Icons.public,
    ),
  ];

  void _onFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignupPage(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return OnboardingSlide(item: _items[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicators
                      Row(
                        children: List.generate(
                          _items.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: _currentPage == index ? 32 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? brandGreen : brandGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      // Next/Start Button
                      Material(
                        color: brandGreen,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            if (_currentPage < _items.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutBack,
                              );
                            } else {
                              _onFinish();
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: Row(
                              children: [
                                Text(
                                  _currentPage < _items.length - 1 ? 'Next' : 'Get Started',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentPage < _items.length - 1 ? Icons.arrow_forward : Icons.done_all,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Skip Button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _onFinish,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: brandGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingSlide extends StatefulWidget {
  final OnboardingItem item;

  const OnboardingSlide({super.key, required this.item});

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF0FA71A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 3D Animated Icon
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(math.sin(_controller.value * 2 * math.pi) * 0.2) // sway
                  ..rotateX(math.cos(_controller.value * 2 * math.pi) * 0.1), // tilt
                alignment: Alignment.center,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: brandGreen.withOpacity(0.05),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: brandGreen.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      widget.item.icon,
                      size: 120,
                      color: brandGreen,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
          Text(
            widget.item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
