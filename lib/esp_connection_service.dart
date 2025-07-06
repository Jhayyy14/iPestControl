import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ESPConnectionService {
  // ESP32 default IP address when in AP mode
  final String _baseUrl;
  bool _isConnected = false;

  // Keep track of current modes
  bool _isPestModeOn = false;
  bool _isInsectModeOn = false;
  int _batteryLevel = 0;

  // Constructor with default IP
  ESPConnectionService({String baseUrl = 'http://192.168.4.1'})
      : _baseUrl = baseUrl;

  // Check connection to ESP32
  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/status'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _isPestModeOn = data['pestMode'] ?? false;
        _isInsectModeOn = data['insectMode'] ?? false;
        _batteryLevel = data['batteryLevel'] ?? 0;
        _isConnected = true;
        return true;
      }
      _isConnected = false;
      return false;
    } catch (e) {
      print('Connection error: $e');
      _isConnected = false;
      return false;
    }
  }

  // Get device status
  Future<Map<String, dynamic>> getStatus() async {
    if (!_isConnected) {
      final connected = await checkConnection();
      if (!connected) {
        return {
          'error': 'Device not connected',
          'connected': false,
          'batteryLevel': 0,
          'pestMode': false,
          'insectMode': false,
        };
      }
    }

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/status'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _batteryLevel = data['batteryLevel'] ?? _batteryLevel;
        _isPestModeOn = data['pestMode'] ?? _isPestModeOn;
        _isInsectModeOn = data['insectMode'] ?? _isInsectModeOn;

        return {
          'connected': true,
          'device': data['device'] ?? 'iPestControl',
          'version': data['version'] ?? '1.0.0',
          'batteryLevel': _batteryLevel,
          'pestMode': _isPestModeOn,
          'insectMode': _isInsectModeOn,
        };
      } else {
        return {
          'error': 'Failed to get status',
          'connected': false,
          'batteryLevel': _batteryLevel,
          'pestMode': _isPestModeOn,
          'insectMode': _isInsectModeOn,
        };
      }
    } catch (e) {
      return {
        'error': e.toString(),
        'connected': false,
        'batteryLevel': _batteryLevel,
        'pestMode': _isPestModeOn,
        'insectMode': _isInsectModeOn,
      };
    }
  }

  // Set pest mode
  Future<bool> setPestMode(bool enabled) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/pestmode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': enabled}),
      )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _isPestModeOn = enabled;
        return true;
      }
      return false;
    } catch (e) {
      print('Error setting pest mode: $e');
      return false;
    }
  }

  // Set insect mode
  Future<bool> setInsectMode(bool enabled) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/insectmode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': enabled}),
      )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _isInsectModeOn = enabled;
        return true;
      }
      return false;
    } catch (e) {
      print('Error setting insect mode: $e');
      return false;
    }
  }

  // Start periodic status polling
  Timer? _statusTimer;

  void startStatusPolling({int intervalSeconds = 5, Function? onUpdate}) {
    // Cancel any existing timer
    _statusTimer?.cancel();

    // Create new timer for polling
    _statusTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      final status = await getStatus();
      if (onUpdate != null) {
        onUpdate(status);
      }
    });
  }

  void stopStatusPolling() {
    _statusTimer?.cancel();
    _statusTimer = null;
  }

  // Getters for current state
  bool get isConnected => _isConnected;
  bool get isPestModeOn => _isPestModeOn;
  bool get isInsectModeOn => _isInsectModeOn;
  int get batteryLevel => _batteryLevel;

  // For cleanup
  void dispose() {
    stopStatusPolling();
  }
}