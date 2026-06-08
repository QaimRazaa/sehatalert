// lib/data/model/medicine/medicine_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  final String id;
  final String uid;
  final String medicineName;
  final String medicineType;
  final String dosage;
  final String frequency;
  final List<String> timings;
  final Map<String, String> reminderTimes; // e.g. {'Morning': '08:00', 'Evening': '18:00'}
  final String? mealTiming;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final String? notes;
  final DateTime createdAt;

  MedicineModel({
    required this.id,
    required this.uid,
    required this.medicineName,
    required this.medicineType,
    required this.dosage,
    required this.frequency,
    required this.timings,
    required this.reminderTimes,
    this.mealTiming,
    required this.startDate,
    this.endDate,
    required this.isOngoing,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'medicineName': medicineName,
      'medicineType': medicineType,
      'dosage': dosage,
      'frequency': frequency,
      'timings': timings,
      'reminderTimes': reminderTimes,
      'mealTiming': mealTiming,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isOngoing': isOngoing,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MedicineModel copyWith({String? id}) {
    return MedicineModel(
      id: id ?? this.id,
      uid: uid,
      medicineName: medicineName,
      medicineType: medicineType,
      dosage: dosage,
      frequency: frequency,
      timings: timings,
      reminderTimes: reminderTimes,
      mealTiming: mealTiming,
      startDate: startDate,
      endDate: endDate,
      isOngoing: isOngoing,
      notes: notes,
      createdAt: createdAt,
    );
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicineModel(
      id: documentId,
      uid: map['uid'] ?? '',
      medicineName: map['medicineName'] ?? '',
      medicineType: map['medicineType'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      timings: List<String>.from(map['timings'] ?? []),
      reminderTimes: Map<String, String>.from(map['reminderTimes'] ?? {}),
      mealTiming: map['mealTiming'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      isOngoing: map['isOngoing'] ?? false,
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}