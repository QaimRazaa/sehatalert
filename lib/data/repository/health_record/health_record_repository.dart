import '../../../utils/exceptions/exceptions.dart';
import '../../model/health_record/health_record_model.dart';
import '../../services/health_record/health_record_service.dart';

class HealthRecordRepository {
  final HealthRecordService healthRecordService = HealthRecordService();

  Future<void> createHealthRecord(HealthRecordModel record) async {
    try {
      await healthRecordService.createHealthRecord(record);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to save health record', code: 'create-record-failed');
    }
  }

  Future<List<HealthRecordModel>> getHealthRecordsByDisease(String userId, String diseaseType) async {
    try {
      return await healthRecordService.getHealthRecordsByDisease(userId, diseaseType);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records', code: 'fetch-records-failed');
    }
  }

  Future<List<HealthRecordModel>> getAllHealthRecords(String userId) async {
    try {
      return await healthRecordService.getAllHealthRecords(userId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch health records', code: 'fetch-records-failed');
    }
  }

  Stream<List<HealthRecordModel>> getHealthRecordsByDiseaseStream(String userId, String diseaseType) {
    return healthRecordService.getHealthRecordsByDiseaseStream(userId, diseaseType);
  }

  Future<void> updateHealthRecord(HealthRecordModel record) async {
    try {
      await healthRecordService.updateHealthRecord(record);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to update health record', code: 'update-record-failed');
    }
  }

  Future<void> deleteHealthRecord(String userId, String recordId) async {
    try {
      await healthRecordService.deleteHealthRecord(userId, recordId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete health record', code: 'delete-record-failed');
    }
  }

  Future<bool> recordExists(String userId, String recordId) async {
    try {
      return await healthRecordService.recordExists(userId, recordId);
    } catch (e) {
      return false;
    }
  }
}
