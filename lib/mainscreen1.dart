import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'wifi_connect_screen.dart';
import 'mode_screen.dart';
import 'battery_status_screen.dart';
import 'info_screen.dart';
import 'esp_connection_service.dart'; // Import the ESP service
import 'wifi_connection_dialog.dart'; // Import the WiFi dialog
import 'pest_status_screen.dart';
import 'thermal_camera_screen.dart';
import 'thermal_display_widget.dart';
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // ESP32 connection
  ESPConnectionService? _espService;
  bool _isConnected = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    // Show "No Device Found" alert when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNoDeviceAlert();
      _tryAutoConnect(); // Try to auto-connect to ESP device
    });
  }

  @override
  void dispose() {
    _espService?.dispose(); // Clean up ESP service when screen is disposed
    super.dispose();
  }

  // Try to connect to the last known device
  void _tryAutoConnect() async {
    setState(() => _isConnecting = true);

    try {
      final service = ESPConnectionService(); // Default IP 192.168.4.1
      final connected = await service.checkConnection();

      if (connected) {
        _setupESPService(service);
      }
    } catch (e) {
      // Silently fail on auto-connect
      print('Auto-connect failed: $e');
    }

    setState(() => _isConnecting = false);
  }

  // Set up ESP service after successful connection
  void _setupESPService(ESPConnectionService service) {
    _espService = service;
    setState(() => _isConnected = true);

    // Start polling for updates
    service.startStatusPolling(onUpdate: (status) {
      setState(() {
        _isConnected = status['connected'] ?? false;
      });
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Connected to iPestControl device',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFFE8E8E8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        duration: const Duration(seconds: 3),
        elevation: 0,
      ),
    );
  }

  // Show connection dialog
  void _connectToDevice() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => WiFiConnectionDialog(
        onConnected: _setupESPService,
      ),
    );
  }

  void _showNoDeviceAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'No Device Found',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFFE8E8E8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        duration: const Duration(seconds: 3),
        elevation: 0,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
    switch (index) {
      case 0:
      // Home - current screen
        break;
      case 1:
      // Navigate to WiFi screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WifiConnectScreen()),
        );
        break;
      case 2:
      // View/Monitor
       // _showMonitorDialog();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ThermalCameraScreen()),
        );
        break;
      case 3:
      // Settings/Menu
        _showSettingsDialog();
        break;
      case 4:
      // Info/About
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoScreen()),
        );
        break;
    }
  }

  void _showMonitorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Monitor'),
          content: const Text('Device monitoring view'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: const Text('App settings and configuration'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F), // Dark teal background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C5F6F),
        title: const Text(
          'iPestControl',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // WiFi connection indicator/button
          IconButton(
            icon: _isConnecting
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
            )
                : Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.greenAccent : Colors.white70,
            ),
            onPressed: _isConnecting ? null : _connectToDevice,
            tooltip: _isConnected ? 'Connected' : 'Connect to Device',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Space for the snackbar

              // MODE Button - now passes ESP service
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Mode Screen with ESP service
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModeScreenWithNav(
                        selectedIndex: 0,
                        espService: _espService,
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8E8E8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'MODE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              // BATTERY Button - now passes ESP service
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Battery Status Screen with ESP service
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BatteryStatusScreen(
                        selectedIndex: 0,
                        espService: _espService,
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8E8E8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'BATTERY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Connection status indicator
              if (_isConnected)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Connected to iPestControl Device',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
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