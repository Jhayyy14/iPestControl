import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'wifi_connect_screen.dart';
import 'mode_screen.dart';
import 'battery_status_screen.dart';
import 'about_screen.dart';
import 'credit_screen.dart'; // Import the new Credits screen

class InfoScreen extends StatefulWidget {
  final int selectedIndex;

  const InfoScreen({super.key, this.selectedIndex = 4});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
    switch (index) {
      case 0:
      // Return to main screen
        Navigator.pop(context);
        break;
      case 1:
      // Navigate to WiFi screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WifiConnectScreen()),
        );
        break;
      case 2:
      // View/Monitor
        Navigator.pop(context);
        break;
      case 3:
      // Settings/Menu
        Navigator.pop(context);
        break;
      case 4:
      // Already on Info screen
        break;
    }
  }

  // Navigate to About screen
  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  // Navigate to Credits screen
  void _navigateToCredits() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreditsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F), // Match main app's background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C5F6F),
        title: const Text(
          'IPESTCONTROL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // About section - navigates to About screen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C5F6F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _navigateToAbout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5F6F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    child: const Text(
                      'Click Here',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Credits section - now navigates to Credits screen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C5F6F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _navigateToCredits, // Navigate to Credits screen
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5F6F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    child: const Text(
                      'Click Here',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: const Color(0xFF2C5F6F),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home Icon
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            // WiFi Icon
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: FaIcon(
                FontAwesomeIcons.wifi,
                color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            // View/Eye Icon
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: FaIcon(
                FontAwesomeIcons.eye,
                color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            // Menu/Settings Icon
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: FaIcon(
                FontAwesomeIcons.bookOpen,
                color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            // Info Icon
            IconButton(
              onPressed: () => _onItemTapped(4),
              icon: FaIcon(
                FontAwesomeIcons.circleInfo,
                color: _selectedIndex == 4 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}