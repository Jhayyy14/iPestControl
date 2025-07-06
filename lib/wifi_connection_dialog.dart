import 'package:flutter/material.dart';
import 'esp_connection_service.dart';

class WiFiConnectionDialog extends StatefulWidget {
  final Function(ESPConnectionService) onConnected;

  const WiFiConnectionDialog({
    Key? key,
    required this.onConnected,
  }) : super(key: key);

  @override
  _WiFiConnectionDialogState createState() => _WiFiConnectionDialogState();
}

class _WiFiConnectionDialogState extends State<WiFiConnectionDialog> {
  final TextEditingController _ipController =
  TextEditingController(text: '192.168.4.1');
  bool _isConnecting = false;
  String _statusMessage = 'Enter the IP address of your iPestControl device';

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Attempting to connect...';
    });

    try {
      final service = ESPConnectionService(baseUrl: 'http://${_ipController.text}');
      final connected = await service.checkConnection();

      setState(() {
        _isConnecting = false;
      });

      if (connected) {
        setState(() {
          _statusMessage = 'Successfully connected!';
        });

        // Pass the service back to caller
        widget.onConnected(service);

        // Close dialog after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(true); // Return success
        });
      } else {
        setState(() {
          _statusMessage =
          'Failed to connect. Make sure your phone is connected to the iPestControl WiFi network.';
        });
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFE8E8E8),
      title: const Text(
        'Connect to Device',
        style: TextStyle(
          color: Color(0xFF2C5F6F),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _statusMessage,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ipController,
            decoration: InputDecoration(
              labelText: 'IP Address',
              hintText: 'Default: 192.168.4.1',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C5F6F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Connect to "iPestControl" WiFi'),
                Text('• Password: pestcontrol123'),
                Text('• Default IP is 192.168.4.1'),
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isConnecting ? null : _connect,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C5F6F),
            foregroundColor: Colors.white,
          ),
          child: _isConnecting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text('Connect'),
        ),
      ],
    );
  }
}