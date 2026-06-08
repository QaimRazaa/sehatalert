import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/pharmacy/pharmacy_model.dart';

class PharmacyService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createPharmacy(PharmacyModel pharmacy) async {
    try {
      await firestore
          .collection('users')
          .doc(pharmacy.userId)
          .collection('pharmacies')
          .doc(pharmacy.id)
          .set(pharmacy.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to save pharmacy: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to save pharmacy',
        code: 'create-pharmacy-failed',
      );
    }
  }

  Future<List<PharmacyModel>> getAllPharmacies(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('pharmacies')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PharmacyModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch pharmacies: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch pharmacies',
        code: 'fetch-pharmacies-failed',
      );
    }
  }

  Stream<List<PharmacyModel>> getPharmaciesStream(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('pharmacies')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => PharmacyModel.fromMap(doc.data(), doc.id))
                .toList(),
          );
    } catch (e) {
      return Stream.error(
        FirestoreException(
          message: 'Failed to stream pharmacies',
          code: 'stream-pharmacies-failed',
        ),
      );
    }
  }

  Future<void> updatePharmacy(PharmacyModel pharmacy) async {
    try {
      await firestore
          .collection('users')
          .doc(pharmacy.userId)
          .collection('pharmacies')
          .doc(pharmacy.id)
          .update(pharmacy.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update pharmacy: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update pharmacy',
        code: 'update-pharmacy-failed',
      );
    }
  }

  Future<void> deletePharmacy(String userId, String pharmacyId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('pharmacies')
          .doc(pharmacyId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to delete pharmacy: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete pharmacy',
        code: 'delete-pharmacy-failed',
      );
    }
  }

  Future<bool> pharmacyExists(String userId, String pharmacyId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('pharmacies')
          .doc(pharmacyId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
