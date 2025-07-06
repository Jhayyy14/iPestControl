import 'package:flutter/material.dart';
import 'mainscreen1.dart'; // Import your main screen

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToMainApp() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const MainAppScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  // Content for each onboarding page
  final List<Map<String, String>> _pages = [
    {
      'title': 'iPestControl',
      'description': 'An Android Application capable of controlling a hardware system to repel pest and exterminate insects',
    },
    {
      'title': 'Control at your Fingertips',
      'description': 'Monitor pest activity and control devices remotely using your phone.',
    },
    {
      'title': 'Automatic Pest Detection',
      'description': 'The system uses sensors to detect pests and activate deterrents in real-time.',
    },
    {
      'title': 'Automatic Pest Detection',
      'description': 'Our system uses sensors to detect pests and activate deterrents in real-time.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F),
      body: SafeArea(
        child: Column(
          children: [
            // Main content section with PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    bool isLastPage = index == _pages.length - 1;

    return Padding(
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
                  // Title and description
                  Column(
                    children: [
                      Text(
                        _pages[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _pages[index]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  // Navigation section
                  isLastPage ? _buildGetStartedButton() : _buildNavigationRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation row with skip, dots, and next
  Widget _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip button
        TextButton(
          onPressed: _navigateToMainApp,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Page indicators
        Row(
          children: List.generate(_pages.length, (index) {
            bool isCurrentPage = _currentPage == index;
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrentPage ? 30 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isCurrentPage
                      ? const Color(0xFF2C5F6F)
                      : Colors.black38,
                  // Only use borderRadius for rectangle shape (active indicator)
                  borderRadius: isCurrentPage ? BorderRadius.circular(3) : null,
                  shape: isCurrentPage ? BoxShape.rectangle : BoxShape.circle,
                ),
              ),
            );
          }),
        ),

        // Next button
        TextButton(
          onPressed: () {
            _pageController.animateToPage(
              _currentPage + 1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Get Started button for last page
  Widget _buildGetStartedButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _navigateToMainApp,
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
        const SizedBox(height: 24),
        // Page indicators for last page
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_pages.length, (index) {
            bool isCurrentPage = _currentPage == index;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrentPage ? 30 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isCurrentPage
                    ? const Color(0xFF2C5F6F)
                    : Colors.black38,
                // Only use borderRadius for rectangle shape (active indicator)
                borderRadius: isCurrentPage ? BorderRadius.circular(3) : null,
                shape: isCurrentPage ? BoxShape.rectangle : BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}