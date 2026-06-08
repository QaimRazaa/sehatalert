import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/health_record/health_record_model.dart';

class HealthRecordService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createHealthRecord(HealthRecordModel record) async {
    try {
      await firestore
          .collection('users')
          .doc(record.userId)
          .collection('healthRecords')
          .doc(record.id)
          .set(record.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to create health record: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to create health record', code: 'create-record-failed');
    }
  }

  Future<List<HealthRecordModel>> getHealthRecordsByDisease(String userId, String diseaseType) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('healthRecords')
          .where('diseaseType', isEqualTo: diseaseType)
          .orderBy('createdAt', descending: true) // ← Changed: only order by createdAt
          .get();

      return querySnapshot.docs.map((doc) => HealthRecordModel.fromMap(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records', code: 'fetch-records-failed');
    }
  }

  Future<List<HealthRecordModel>> getAllHealthRecords(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('healthRecords')
          .orderBy('createdAt', descending: true) // ← Changed: only order by createdAt
          .get();

      return querySnapshot.docs.map((doc) => HealthRecordModel.fromMap(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records', code: 'fetch-records-failed');
    }
  }

  Stream<List<HealthRecordModel>> getHealthRecordsByDiseaseStream(String userId, String diseaseType) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('healthRecords')
          .where('diseaseType', isEqualTo: diseaseType)
          .orderBy('createdAt', descending: true) // ← Changed: only order by createdAt
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => HealthRecordModel.fromMap(doc.data(), doc.id)).toList());
    } catch (e) {
      return Stream.error(
        FirestoreException(message: 'Failed to stream health records', code: 'stream-records-failed'),
      );
    }
  }

  Future<void> updateHealthRecord(HealthRecordModel record) async {
    try {
      await firestore
          .collection('users')
          .doc(record.userId)
          .collection('healthRecords')
          .doc(record.id)
          .update(record.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to update health record: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update health record', code: 'update-record-failed');
    }
  }

  Future<void> deleteHealthRecord(String userId, String recordId) async {
    try {
      await firestore.collection('users').doc(userId).collection('healthRecords').doc(recordId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to delete health record: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete health record', code: 'delete-record-failed');
    }
  }

  Future<bool> recordExists(String userId, String recordId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).collection('healthRecords').doc(recordId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
