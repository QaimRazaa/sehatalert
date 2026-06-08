// lib/data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContact {
  final String name;
  final String relationship;
  final String phoneNumber;

  EmergencyContact({required this.name, required this.relationship, required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {'name': name, 'relationship': relationship, 'phoneNumber': phoneNumber};
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}

class PatientInfo {
  final DateTime dateOfBirth;
  final String gender;
  final String? bloodGroup;
  final String allergies;
  final EmergencyContact emergencyContact;
  final String? height;
  final String? weight;
  final String? city;
  final List<String> diseases;

  PatientInfo({
    required this.dateOfBirth,
    required this.gender,
    this.bloodGroup,
    required this.allergies,
    required this.emergencyContact,
    this.height,
    this.weight,
    this.city,
    required this.diseases,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'emergencyContact': emergencyContact.toMap(),
      'height': height,
      'weight': weight,
      'city': city,
      'diseases': diseases,
    };
  }

  factory PatientInfo.fromMap(Map<String, dynamic> map) {
    return PatientInfo(
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      bloodGroup: map['bloodGroup'],
      allergies: map['allergies'] ?? '',
      emergencyContact: EmergencyContact.fromMap(map['emergencyContact'] ?? {}),
      height: map['height'],
      weight: map['weight'],
      city: map['city'],
      diseases: List<String>.from(map['diseases'] ?? []),
    );
  }
}

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PatientInfo? patientInfo;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
    this.patientInfo,
  });

  bool get hasCompletedProfile => patientInfo != null && patientInfo!.diseases.isNotEmpty;

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'patientInfo': patientInfo?.toMap(),
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      patientInfo: map['patientInfo'] != null ? PatientInfo.fromMap(map['patientInfo']) : null,
    );
  }

  // Create empty user model
  static UserModel empty() {
    return UserModel(uid: '', fullName: '', email: '', phoneNumber: '', createdAt: DateTime.now());
  }

  // CopyWith method for updating user data
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    PatientInfo? patientInfo,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patientInfo: patientInfo ?? this.patientInfo,
    );
  }
}
