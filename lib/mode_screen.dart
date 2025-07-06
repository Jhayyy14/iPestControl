import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'wifi_connect_screen.dart';
import 'esp_connection_service.dart';
import 'wifi_connection_dialog.dart';

class ModeScreenWithNav extends StatefulWidget {
  final int selectedIndex;
  final ESPConnectionService? espService;

  const ModeScreenWithNav({super.key, this.selectedIndex = 0, this.espService,});

  @override
  State<ModeScreenWithNav> createState() => _ModeScreenWithNavState();
}

class _ModeScreenWithNavState extends State<ModeScreenWithNav> {
  bool _isPestModeEnabled = false;
  bool _isInsectModeEnabled = false;
  late int _selectedIndex;

  // ESP32 connection
  ESPConnectionService? _espService;
  bool _isConnected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    // Try to auto-connect to last known device
    _tryAutoConnect();
  }

  @override
  void dispose() {
    _espService?.dispose();
    super.dispose();
  }

  void _tryAutoConnect() async {
    // In a real app, you would store the last IP address and try to reconnect
    // For now, we'll just use the default IP
    setState(() => _isLoading = true);

    try {
      final service = ESPConnectionService();
      final connected = await service.checkConnection();

      if (connected) {
        _setupESPService(service);
      }
    } catch (e) {
      // Silently fail on auto-connect
      print('Auto-connect failed: $e');
    }

    setState(() => _isLoading = false);
  }

  void _setupESPService(ESPConnectionService service) {
    _espService = service;
    setState(() {
      _isConnected = true;
      _isPestModeEnabled = service.isPestModeOn;
      _isInsectModeEnabled = service.isInsectModeOn;
    });

    // Start polling for updates
    service.startStatusPolling(onUpdate: (status) {
      setState(() {
        _isPestModeEnabled = status['pestMode'] ?? _isPestModeEnabled;
        _isInsectModeEnabled = status['insectMode'] ?? _isInsectModeEnabled;
        _isConnected = status['connected'] ?? false;
      });
    });
  }

  void _showConnectionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => WiFiConnectionDialog(
        onConnected: _setupESPService,
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Connected to iPestControl device',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
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
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5F6F), // Match main app's background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C5F6F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MODE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // WiFi connection button
          IconButton(
            icon: _isLoading
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
            onPressed: _isLoading ? null : _showConnectionDialog,
            tooltip: _isConnected ? 'Connected' : 'Connect to Device',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Connection status indicator
            if (_isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Connected to iPestControl Device',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Mode selection container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8), // Light gray background
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pest Mode Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Pest Mode Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C5F6F), // Match main app's color
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rat icon
                            Icon(
                              Icons.pest_control_rodent,
                              color: _isPestModeEnabled ? Colors.greenAccent : Colors.grey[400],
                              size: 30,
                            ),
                            // Red circle with line (only when disabled)
                            if (!_isPestModeEnabled)
                              CustomPaint(
                                size: const Size(60, 60),
                                painter: NoSignPainter(
                                  color: Colors.redAccent,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Switch
                      CupertinoSwitch(
                        value: _isPestModeEnabled,
                        onChanged: (value) async {
                          if (!_isConnected) {
                            _showConnectionDialog();
                            return;
                          }

                          setState(() => _isLoading = true);
                          final success = await _espService?.setPestMode(value) ?? false;
                          setState(() => _isLoading = false);

                          if (success) {
                            setState(() => _isPestModeEnabled = value);

                            // Show feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value ? 'Pest Mode Enabled' : 'Pest Mode Disabled',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: const Color(0xFFE8E8E8),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                duration: const Duration(seconds: 2),
                                elevation: 0,
                              ),
                            );
                          } else {
                            // Show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Failed to update mode. Check connection.',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              ),
                            );
                          }
                        },
                        activeColor: _isConnected ? Colors.green : Colors.grey,
                        trackColor: Colors.grey[350],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Pest Mode Label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C5F6F), // Match main app's color
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Pest Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Insect Mode Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Insect Mode Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C5F6F), // Match main app's color
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mosquito icon
                            Icon(
                              Icons.pest_control,
                              color: _isInsectModeEnabled ? Colors.greenAccent : Colors.grey[400],
                              size: 30,
                            ),
                            // Red circle with line (only when disabled)
                            if (!_isInsectModeEnabled)
                              CustomPaint(
                                size: const Size(60, 60),
                                painter: NoSignPainter(
                                  color: Colors.redAccent,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Switch
                      CupertinoSwitch(
                        value: _isInsectModeEnabled,
                        onChanged: (value) async {
                          if (!_isConnected) {
                            _showConnectionDialog();
                            return;
                          }

                          setState(() => _isLoading = true);
                          final success = await _espService?.setInsectMode(value) ?? false;
                          setState(() => _isLoading = false);

                          if (success) {
                            setState(() => _isInsectModeEnabled = value);

                            // Show feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value ? 'Insect Mode Enabled' : 'Insect Mode Disabled',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: const Color(0xFFE8E8E8),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                duration: const Duration(seconds: 2),
                                elevation: 0,
                              ),
                            );
                          } else {
                            // Show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Failed to update mode. Check connection.',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              ),
                            );
                          }
                        },
                        activeColor: _isConnected ? Colors.green : Colors.grey,
                        trackColor: Colors.grey[350],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Insect Mode Label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C5F6F), // Match main app's color
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Insect Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Connection guide when not connected
            if (!_isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Not connected to any device',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect to your iPestControl device to enable remote control',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _showConnectionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8E8E8),
                        foregroundColor: const Color(0xFF2C5F6F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Connect Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
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

// Keep the original NoSignPainter class
class NoSignPainter extends CustomPainter {
  final Color color;

  NoSignPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 5,
      paint,
    );

    // Draw diagonal line
    canvas.drawLine(
      Offset(size.width / 4, size.height / 4),
      Offset(size.width * 3 / 4, size.height * 3 / 4),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}