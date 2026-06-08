import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordModel {
  final String id;
  final String userId;
  final String diseaseType;
  final DateTime date;
  final String time;
  final Map<String, dynamic> readings;
  final String? notes;
  final DateTime createdAt;

  HealthRecordModel({
    required this.id,
    required this.userId,
    required this.diseaseType,
    required this.date,
    required this.time,
    required this.readings,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'diseaseType': diseaseType,
      'date': Timestamp.fromDate(date),
      'time': time,
      'readings': readings,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory HealthRecordModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HealthRecordModel(
      id: documentId,
      userId: map['userId'] ?? '',
      diseaseType: map['diseaseType'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      readings: Map<String, dynamic>.from(map['readings'] ?? {}),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  static HealthRecordModel empty() {
    return HealthRecordModel(
      id: '',
      userId: '',
      diseaseType: '',
      date: DateTime.now(),
      time: '',
      readings: {},
      createdAt: DateTime.now(),
    );
  }

  HealthRecordModel copyWith({
    String? id,
    String? userId,
    String? diseaseType,
    DateTime? date,
    String? time,
    Map<String, dynamic>? readings,
    String? notes,
    DateTime? createdAt,
  }) {
    return HealthRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      diseaseType: diseaseType ?? this.diseaseType,
      date: date ?? this.date,
      time: time ?? this.time,
      readings: readings ?? this.readings,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
