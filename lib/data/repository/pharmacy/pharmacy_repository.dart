import '../../../utils/exceptions/exceptions.dart';
import '../../model/pharmacy/pharmacy_model.dart';
import '../../services/pharmacy/pharmacy_service.dart';

class PharmacyRepository {
  final PharmacyService pharmacyService = PharmacyService();

  Future<void> createPharmacy(PharmacyModel pharmacy) async {
    try {
      await pharmacyService.createPharmacy(pharmacy);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to save pharmacy',
        code: 'create-pharmacy-failed',
      );
    }
  }

  Future<List<PharmacyModel>> getAllPharmacies(String userId) async {
    try {
      return await pharmacyService.getAllPharmacies(userId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch pharmacies',
        code: 'fetch-pharmacies-failed',
      );
    }
  }

  Stream<List<PharmacyModel>> getPharmaciesStream(String userId) {
    return pharmacyService.getPharmaciesStream(userId);
  }

  Future<void> updatePharmacy(PharmacyModel pharmacy) async {
    try {
      await pharmacyService.updatePharmacy(pharmacy);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update pharmacy',
        code: 'update-pharmacy-failed',
      );
    }
  }

  Future<void> deletePharmacy(String userId, String pharmacyId) async {
    try {
      await pharmacyService.deletePharmacy(userId, pharmacyId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete pharmacy',
        code: 'delete-pharmacy-failed',
      );
    }
  }

  Future<bool> pharmacyExists(String userId, String pharmacyId) async {
    try {
      return await pharmacyService.pharmacyExists(userId, pharmacyId);
    } catch (e) {
      return false;
    }
  }
}
