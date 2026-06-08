import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyModel {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final String? address;
  final String? city;
  final String? notes;
  final DateTime createdAt;

  PharmacyModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.city,
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
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PharmacyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PharmacyModel(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'],
      city: map['city'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  static PharmacyModel empty() {
    return PharmacyModel(
      id: '',
      userId: '',
      name: '',
      phoneNumber: '',
      createdAt: DateTime.now(),
    );
  }

  PharmacyModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumber,
    String? address,
    String? city,
    String? notes,
    DateTime? createdAt,
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
