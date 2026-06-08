// lib/data/services/medicine/medicine_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/medicine/medicine_model.dart';

class MedicineFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String medicinesCollection = 'medicines';

  // Create medicine
  Future<String> createMedicine(MedicineModel medicine) async {
    try {
      print('=== Creating Medicine ===');
      print('Medicine Data: ${medicine.toMap()}');

      final docRef = await firestore.collection(medicinesCollection).add(medicine.toMap());

      print('Medicine created with ID: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception: ${e.code} - ${e.message}');
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      print('Unknown Error: $e');
      throw FirestoreException(message: 'Failed to create medicine', code: 'unknown');
    }
  }

  // Get all medicines for a user
  Future<List<MedicineModel>> getUserMedicines(String uid) async {
    try {
      print('=== Fetching Medicines ===');
      print('Querying for UID: $uid');

      final querySnapshot = await firestore
          .collection(medicinesCollection)
          .where('uid', isEqualTo: uid)
      // .orderBy('createdAt', descending: true) // Comment this out temporarily
          .get();

      print('Documents found: ${querySnapshot.docs.length}');

      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Document Data: ${doc.data()}');
      }

      final medicines = querySnapshot.docs
          .map((doc) => MedicineModel.fromMap(doc.data(), doc.id))
          .toList();

      // Sort in memory instead
      medicines.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('Medicines parsed: ${medicines.length}');

      return medicines;
    } on FirebaseException catch (e) {
      print('Firebase Exception: ${e.code} - ${e.message}');
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      print('Unknown Error: $e');
      throw FirestoreException(message: 'Failed to retrieve medicines', code: 'unknown');
    }
  }

  // Get medicines stream for real-time updates
  Stream<List<MedicineModel>> getUserMedicinesStream(String uid) {
    try {
      return firestore
          .collection(medicinesCollection)
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => MedicineModel.fromMap(doc.data(), doc.id))
          .toList());
    } catch (e) {
      throw FirestoreException(message: 'Failed to get medicines stream', code: 'unknown');
    }
  }

  // Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    try {
      print('=== Deleting Medicine ===');
      print('Medicine ID: $medicineId');

      await firestore.collection(medicinesCollection).doc(medicineId).delete();

      print('Medicine deleted successfully');
    } on FirebaseException catch (e) {
      print('Firebase Exception: ${e.code} - ${e.message}');
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      print('Unknown Error: $e');
      throw FirestoreException(message: 'Failed to delete medicine', code: 'unknown');
    }
  }

  // Update medicine
  Future<void> updateMedicine(String medicineId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(medicinesCollection).doc(medicineId).update(data);
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update medicine', code: 'unknown');
    }
  }
}