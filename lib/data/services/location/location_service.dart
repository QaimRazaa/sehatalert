import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _emergencyWebhookUrl =
      'https://lifelink.app.n8n.cloud/webhook-test/emergency-location';

  Future<Position?> getPosition() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  Future<String?> getLocationLink() async {
    final position = await getPosition();
    if (position == null) return null;
    return 'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
  }

  Future<void> sendEmergencyAlert(String uid) async {
    try {
      final position = await getPosition();
      final mapsLink = position != null
          ? 'https://www.google.com/maps?q=${position.latitude},${position.longitude}'
          : null;

      final response = await http
          .post(
            Uri.parse(_emergencyWebhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'patient_id': uid,
              'lat': position?.latitude,
              'lng': position?.longitude,
              'maps_link': mapsLink ?? 'unavailable',
              'timestamp': DateTime.now().toIso8601String(),
              'trigger': 'manual_emergency',
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Webhook error ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }
}
