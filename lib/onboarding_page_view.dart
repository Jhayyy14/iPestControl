import 'package:flutter/material.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _indicatorController;
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'iPestControl',
      description: 'An Android Application capable of controlling a hardware system to repel pest and exterminate insects',
    ),
    OnboardingData(
      title: 'Control at your Fingertips',
      description: 'Monitor pest activity and control devices remotely using your phone.',
    ),
    OnboardingData(
      title: 'Automatic Pest Detection',
      description: 'The system uses sensors to detect pests and activate deterrents in real-time.',
    ),
    OnboardingData(
      title: 'Automatic Pest Detection',
      description: 'Our system uses sensors to detect pests and activate deterrents in real-time.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Navigate to main app
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F),
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data, int index) {
    final isLastPage = index == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Top section with circle
          Expanded(
            flex: 3,
            child: Center(
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
                        data.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      if (isLastPage) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to main app
                              Navigator.of(context).pushReplacementNamed('/main');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C5F6F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Navigation section
                  if (!isLastPage)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button
                        TextButton(
                          onPressed: _skipToEnd,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Animated Page indicators
                        Row(
                          children: List.generate(
                            _pages.length,
                                (indicatorIndex) => GestureDetector(
                              onTap: () => _goToPage(indicatorIndex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == indicatorIndex ? 30 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentPage == indicatorIndex
                                      ? const Color(0xFF2C5F6F)
                                      : Colors.black38,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Next button
                        TextButton(
                          onPressed: _nextPage,
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
                    )
                  else
                  // Only show indicators on last page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (indicatorIndex) => GestureDetector(
                          onTap: () => _goToPage(indicatorIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == indicatorIndex ? 30 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == indicatorIndex
                                  ? const Color(0xFF2C5F6F)
                                  : Colors.black38,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;

  OnboardingData({
    required this.title,
    required this.description,
  });
}