import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/exceptions/exceptions.dart';
import '../location/location_service.dart';

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  static const String _webhookUrl =
      'https://lifelink.app.n8n.cloud/webhook-test/voice-incoming';

  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<void> startRecording() async {
    try {
      final dir = await getTemporaryDirectory();
      _currentPath = '${dir.path}/${const Uuid().v4()}.mp3';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // produces m4a/aac, we rename to mp3
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentPath!,
      );
    } catch (e) {
      _currentPath = null;
      throw FirestoreException(
        message: 'Failed to start recording',
        code: 'record-start-failed',
      );
    }
  }

  Future<void> stopAndProcess(String uid) async {
    try {
      final locationFuture = LocationService().getPosition();
      final path = await _recorder.stop();
      _currentPath = null;

      if (path == null) {
        throw FirestoreException(
          message: 'No audio was captured',
          code: 'record-no-file',
        );
      }

      final file = File(path);
      if (!await file.exists()) {
        throw FirestoreException(
          message: 'Audio file not found',
          code: 'record-file-missing',
        );
      }

      final fileSize = await file.length();
      if (fileSize < 500) {
        await file.delete();
        throw FirestoreException(
          message: 'Recording too short, please try again',
          code: 'record-too-short',
        );
      }

      // Send as multipart form data to webhook
      final request = http.MultipartRequest('POST', Uri.parse(_webhookUrl));

      // Add patient_id, timestamp and location as fields
      final position = await locationFuture;
      request.fields['patient_id'] = uid;
      request.fields['timestamp'] = DateTime.now().toIso8601String();
      if (position != null) {
        request.fields['lat'] = position.latitude.toString();
        request.fields['lng'] = position.longitude.toString();
        request.fields['maps_link'] =
            'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
      }

      // Attach audio file
      request.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          file.path,
          filename: '${uid}_${DateTime.now().millisecondsSinceEpoch}.mp3',
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      // Clean up local file
      await file.delete();

      if (streamedResponse.statusCode < 200 ||
          streamedResponse.statusCode >= 300) {
        throw FirestoreException(
          message: 'Failed to send voice note (${streamedResponse.statusCode})',
          code: 'webhook-failed',
        );
      }
    } on FirestoreException {
      rethrow;
    } on SocketException {
      throw FirestoreException(
        message: 'No internet connection',
        code: 'no-internet',
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to process voice note',
        code: 'unknown',
      );
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _recorder.cancel();
      if (_currentPath != null) {
        final file = File(_currentPath!);
        if (await file.exists()) await file.delete();
        _currentPath = null;
      }
    } catch (_) {}
  }

  void dispose() {
    _recorder.dispose();
  }
}
