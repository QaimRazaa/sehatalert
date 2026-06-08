// lib/data/repositories/medicine/medicine_repository.dart

import '../../model/medicine/medicine_model.dart';
import '../../services/medicine/medicine_service.dart';
import '../../services/notification/notification_service.dart';

class MedicineRepository {
  final MedicineFirestoreService firestoreService = MedicineFirestoreService();

  // Create medicine
  Future<String> createMedicine(MedicineModel medicine) async {
    try {
      return await firestoreService.createMedicine(medicine);
    } catch (e) {
      rethrow;
    }
  }

  // Get all medicines for a user
  Future<List<MedicineModel>> getUserMedicines(String uid) async {
    try {
      return await firestoreService.getUserMedicines(uid);
    } catch (e) {
      rethrow;
    }
  }

  // Get medicines stream
  Stream<List<MedicineModel>> getUserMedicinesStream(String uid) {
    try {
      return firestoreService.getUserMedicinesStream(uid);
    } catch (e) {
      rethrow;
    }
  }

  // Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    try {
      await firestoreService.deleteMedicine(medicineId);
    } catch (e) {
      rethrow;
    }
  }

  // Update medicine
  Future<void> updateMedicine(String medicineId, Map<String, dynamic> data) async {
    try {
      await firestoreService.updateMedicine(medicineId, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scheduleReminders(MedicineModel medicine) async {
    await NotificationService().scheduleRemindersForMedicine(medicine);
  }

  Future<void> cancelReminders(MedicineModel medicine) async {
    await NotificationService().cancelRemindersForMedicine(
      medicine.id,
      medicine.reminderTimes.length,
    );
  }
}