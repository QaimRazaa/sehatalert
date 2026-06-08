import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final String? address;
  final String? city;
  final String? openingHours;
  final String? notes;
  final DateTime createdAt;

  LabModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.city,
    this.openingHours,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'openingHours': openingHours,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory LabModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LabModel(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'],
      city: map['city'],
      openingHours: map['openingHours'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  static LabModel empty() {
    return LabModel(
      id: '',
      userId: '',
      name: '',
      phoneNumber: '',
      createdAt: DateTime.now(),
    );
  }

  LabModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumber,
    String? address,
    String? city,
    String? openingHours,
    String? notes,
    DateTime? createdAt,
  }) {
    return LabModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      openingHours: openingHours ?? this.openingHours,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
