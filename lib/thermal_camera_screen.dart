import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'thermal_display_widget.dart';

class ThermalCameraScreen extends StatefulWidget {
  const ThermalCameraScreen({super.key});

  @override
  _ThermalCameraScreenState createState() => _ThermalCameraScreenState();
}

class _ThermalCameraScreenState extends State<ThermalCameraScreen> {
  String esp32IP = "192.168.4.1"; // Default ESP32 AP IP
  bool isConnected = false;
  bool isLoading = false;
  Timer? _timer;

  Map<String, dynamic>? thermalData;
  Map<String, dynamic>? statusData;

  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ipController.text = esp32IP;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ipController.dispose();
    super.dispose();
  }

  Future<void> connectToESP32() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://$esp32IP/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          statusData = data;
          isConnected = true;
          isLoading = false;
        });

        startDataFetching();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected to ESP32!'), backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Failed to connect');
      }
    } catch (e) {
      setState(() {
        isConnected = false;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void startDataFetching() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchThermalData();
    });
    fetchThermalData(); // Fetch immediately as well
  }

  Future<void> fetchThermalData() async {
    if (!isConnected) return;

    try {
      final response = await http.get(
        Uri.parse('http://$esp32IP/thermal-data'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          thermalData = data;
        });
      }
    } catch (e) {
      print('Error fetching thermal data: $e');
    }
  }

  void disconnect() {
    _timer?.cancel();
    setState(() {
      isConnected = false;
      thermalData = null;
      statusData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thermal Camera'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isConnected)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetchThermalData,
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ESP32 Connection', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ipController,
                            decoration: InputDecoration(
                              labelText: 'ESP32 IP Address',
                              border: OutlineInputBorder(),
                              enabled: !isConnected,
                            ),
                            onChanged: (value) {
                              esp32IP = value;
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: isLoading ? null : (isConnected ? disconnect : connectToESP32),
                          child: isLoading
                              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(isConnected ? 'Disconnect' : 'Connect'),
                        ),
                      ],
                    ),
                    if (isConnected && statusData != null) ...[
                      SizedBox(height: 8),
                      Text('Status: Connected ✅', style: TextStyle(color: Colors.green)),
                      Text('SSID: ${statusData!['ssid']}'),
                      Text('Uptime: ${(statusData!['uptime'] / 1000).toStringAsFixed(0)}s'),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Thermal data section
            if (isConnected) ...[
              if (thermalData != null) ...[
                // Temperature statistics
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTempStat('Min', thermalData!['minTemp'], Colors.blue),
                        _buildTempStat('Avg', thermalData!['avgTemp'], Colors.orange),
                        _buildTempStat('Max', thermalData!['maxTemp'], Colors.red),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Thermal image
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ThermalDisplayWidget(
                        data: List<double>.from(thermalData!['data'].map((x) => x.toDouble())),
                        width: thermalData!['width'],
                        height: thermalData!['height'],
                        minTemp: thermalData!['minTemp'].toDouble(),
                        maxTemp: thermalData!['maxTemp'].toDouble(),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Connect to ESP32 to view thermal data'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTempStat(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('${value.toStringAsFixed(1)}°C',
            style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}