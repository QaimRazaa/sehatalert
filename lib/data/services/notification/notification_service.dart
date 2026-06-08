import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/medicine/medicine_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _alarmChannel = MethodChannel('com.example.sehatalert/alarm');

  Future<void> initialize() async {
    tz.initializeTimeZones();
    _setLocalTimezone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    final parts = payload.split('||');
    final title = parts.isNotEmpty ? parts[0] : 'Medicine Reminder';
    final body = parts.length > 1 ? parts[1] : '';
    _alarmChannel.invokeMethod('launchAlarm', {'title': title, 'body': body});
  }

  Future<void> scheduleRemindersForMedicine(MedicineModel medicine) async {
    final entries = medicine.reminderTimes.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final timing = entries[i].key;
      final timeStr = entries[i].value;
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final notificationId = _notificationId(medicine.id, i);
      final title = 'Medicine Reminder';
      final body = '${medicine.medicineName} — ${medicine.dosage} ($timing)';

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_alarms',
          'Medicine Alarms',
          channelDescription: 'Full-screen alarm-style medicine reminders',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          fullScreenIntent: true,
          autoCancel: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      try {
        await _plugin.zonedSchedule(
          notificationId,
          title,
          body,
          _nextInstanceOfTime(hour, minute),
          details,
          payload: '$title||$body',
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } on PlatformException catch (e) {
        if (e.code == 'exact_alarms_not_permitted') {
          await _plugin.zonedSchedule(
            notificationId,
            title,
            body,
            _nextInstanceOfTime(hour, minute),
            details,
            payload: '$title||$body',
            androidScheduleMode: AndroidScheduleMode.inexact,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
          );
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> cancelRemindersForMedicine(
    String medicineId,
    int timingCount,
  ) async {
    for (int i = 0; i < timingCount; i++) {
      await _plugin.cancel(_notificationId(medicineId, i));
    }
  }

  Future<void> rescheduleAllReminders(List<MedicineModel> medicines) async {
    await _plugin.cancelAll();
    for (final medicine in medicines) {
      if (medicine.reminderTimes.isNotEmpty) {
        await scheduleRemindersForMedicine(medicine);
      }
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  void _setLocalTimezone() {
    final offset = DateTime.now().timeZoneOffset;
    for (final location in tz.timeZoneDatabase.locations.values) {
      try {
        final tzNow = tz.TZDateTime.now(location);
        if (tzNow.timeZoneOffset == offset) {
          tz.setLocalLocation(location);
          return;
        }
      } catch (_) {
        continue;
      }
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  int _notificationId(String medicineId, int index) {
    return (medicineId.hashCode.abs() % 100000) * 10 + index;
  }
}
