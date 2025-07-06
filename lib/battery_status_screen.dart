import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'esp_connection_service.dart';
import 'wifi_connect_screen.dart';

class BatteryStatusScreen extends StatefulWidget {
  final int selectedIndex;

  const BatteryStatusScreen({super.key, this.selectedIndex = 0, ESPConnectionService? espService});

  @override
  State<BatteryStatusScreen> createState() => _BatteryStatusScreenState();
}

class _BatteryStatusScreenState extends State<BatteryStatusScreen> {
  late int _selectedIndex;
  // Battery level for demo - in a real app, you'd get this from device
  final int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
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
      // View/Monitor - Return to main and show dialog
        Navigator.pop(context);
        break;
      case 3:
      // Settings/Menu - Return to main and show dialog
        Navigator.pop(context);
        break;
      case 4:
      // Info/About - Return to main and show dialog
        Navigator.pop(context);
        break;
    }
  }

  // Get battery icon based on level
  Widget _getBatteryIcon(int level) {
    Color batteryColor = Colors.green;

    if (level <= 20) {
      batteryColor = Colors.red;
    } else if (level <= 50) {
      batteryColor = Colors.orange;
    }

    return Container(
      width: 100,
      height: 200,
      decoration: BoxDecoration(
        color: batteryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Battery body
          Container(
            width: 100,
            height: 180,
            decoration: BoxDecoration(
              color: batteryColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          // Battery terminal
          Positioned(
            top: 0,
            child: Container(
              width: 40,
              height: 15,
              decoration: BoxDecoration(
                color: batteryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),

          // Lightning icon
          const Icon(
            Icons.bolt,
            color: Colors.white,
            size: 70,
          ),
        ],
      ),
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
          'BATTERY STATUS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Battery status container
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8), // Light gray background
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Battery icon
                    _getBatteryIcon(_batteryLevel),

                    const SizedBox(height: 20),

                    // Battery percentage
                    Text(
                      '$_batteryLevel%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C5F6F),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      // Bottom Navigation Bar - matching main app's navigation
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