import 'package:flutter/material.dart';
import '../mainscreen1.dart' show MainAppScreen;

class OnboardingScreen4 extends StatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  State<OnboardingScreen4> createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Using easeOutBack instead of elasticOut to keep values bounded within 0-1
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    ));

    // Start button animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _buttonController.forward();
      }
    });
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _getStarted(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainAppScreen(),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _navigateToPage(BuildContext context, int targetPage) {
    switch (targetPage) {
      case 0:
      // Navigate to first screen
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
      // Navigate back two screens
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        break;
      case 2:
      // Navigate back one screen
        _navigateBack(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top section with circle
              Expanded(
                flex: 3,
                child: Center(
                  child: Hero(
                    tag: 'onboarding_circle',
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom section with content
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and description with animation
                      Column(
                        children: [
                          const Text(
                            'Automatic Pest Detection',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Our system uses sensors to detect pests and activate deterrents in real-time.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Animated Get Started button with SafeAnimation
                          FadeTransition(
                            opacity: _buttonAnimation,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _getStarted(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C5F6F),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 4,
                                  shadowColor: const Color(0xFF2C5F6F).withOpacity(0.3),
                                ),
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Enhanced page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Page 1 indicator
                          GestureDetector(
                            onTap: () => _navigateToPage(context, 0),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Page 2 indicator
                          GestureDetector(
                            onTap: () => _navigateToPage(context, 1),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Page 3 indicator
                          GestureDetector(
                            onTap: () => _navigateToPage(context, 2),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Page 4 indicator (current - active)
                          Container(
                            width: 30,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C5F6F),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}