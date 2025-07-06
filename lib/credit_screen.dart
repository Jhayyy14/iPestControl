import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _developers = [
    {
      'nickName': 'Yohan',
      'fullName': 'Jhay D. Peñaloza',
      'role': 'Developer',
      'email': 'penalozajhay10@gmail.com',
      'education': 'BSIT'
    },
    {
      'nickName': 'Marcus',
      'fullName': 'Mark Fuentes',
      'role': 'UI/UX Designer',
      'email': 'markfuentes809@gmail.com',
      'education': 'BSIT'
    },
    {
      'nickName': 'Jo',
      'fullName': 'Marvin M. Gonzales',
      'role': 'Document',
      'email': 'marvin.devops@gmail.com',
      'education': 'BSIT'
    },
    {
      'nickName': 'Charr',
      'fullName': 'Jamescharr Aujero',
      'role': 'Document',
      'email': 'jamescharr.qa@gmail.com',
      'education': 'BSIT'
    },
    {
      'nickName': 'Noir',
      'fullName': 'Ludaygario Tipawan Jr',
      'role': 'Document',
      'email': 'ludy.qa@gmail.com',
      'education': 'BSIT'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2636),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'CREDITS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // DEVELOPERS heading
         /* const Text(
            'DEVELOPERS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          */
          const SizedBox(height: 20),

          // Developer cards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _developers.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _buildDeveloperCard(_developers[index]);
              },
            ),
          ),

          // Pagination dots
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_developers.length, (index) {
                return Container(
                  width: index == _currentPage ? 30 : 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? Colors.lightBlue
                        : Colors.lightBlue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(Map<String, String> developer) {
    return Center(
      child: Container(
        width: 280,
        height: 350,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Avatar area with dark background
            Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFF0D2636),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF0D2636),
                  ),
                ),
              ),
            ),

            // Nick name button
            Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  developer['nickName'] ?? 'Username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Full name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                developer['fullName'] ?? 'Full Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Role button
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D2636),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                developer['role'] ?? 'Role',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Email with icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.email, size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      developer['email'] ?? 'email@example.com',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Education with icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      developer['education'] ?? 'Education',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}