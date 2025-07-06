import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PestStatusScreen extends StatefulWidget {
  final String esp32Ip;
  const PestStatusScreen({super.key, this.esp32Ip = "192.168.4.1"});

  @override
  State<PestStatusScreen> createState() => _PestStatusScreenState();
}

class _PestStatusScreenState extends State<PestStatusScreen> {
  String _statusMessage = "Fetching status...";
  Timer? _timer;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStatus() async {
    try {
      final response = await http.get(Uri.parse("http://${widget.esp32Ip}/status"))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _statusMessage = data["message"] ?? "No message";
          _error = false;
        });
      } else {
        setState(() {
          _statusMessage = "Error: ${response.statusCode}";
          _error = true;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Could not connect to ESP32";
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData iconData;
    Color iconColor;

    if (_error) {
      bgColor = Colors.red.shade100;
      iconData = Icons.error_outline;
      iconColor = Colors.red;
    } else if (_statusMessage == "PEST DETECTED") {
      bgColor = Colors.orange.shade200;
      iconData = Icons.warning;
      iconColor = Colors.orange;
    } else {
      bgColor = Colors.green.shade100;
      iconData = Icons.check_circle_outline;
      iconColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pest Status"),
        backgroundColor: const Color(0xFF2C5F6F),
      ),
      body: Center(
        child: Card(
          color: bgColor,
          elevation: 4,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 64, color: iconColor),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _fetchStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}