import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String id;
  final String userId;
  final String name;
  final String relationship;
  final String phoneNumber;
  final String type;
  final String? email;
  final String? address;
  final DateTime createdAt;

  ContactModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.type,
    this.email,
    this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'type': type,
      'email': email,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ContactModel(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      type: map['type'] ?? '',
      email: map['email'],
      address: map['address'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  static ContactModel empty() {
    return ContactModel(
      id: '',
      userId: '',
      name: '',
      relationship: '',
      phoneNumber: '',
      type: '',
      createdAt: DateTime.now(),
    );
  }

  ContactModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? relationship,
    String? phoneNumber,
    String? type,
    String? email,
    String? address,
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
