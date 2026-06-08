import '../../../utils/exceptions/exceptions.dart';
import '../../model/lab/lab_model.dart';
import '../../services/lab/lab_service.dart';

class LabRepository {
  final LabService labService = LabService();

  Future<void> createLab(LabModel lab) async {
    try {
      await labService.createLab(lab);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to save lab',
        code: 'create-lab-failed',
      );
    }
  }

  Future<List<LabModel>> getAllLabs(String userId) async {
    try {
      return await labService.getAllLabs(userId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch labs',
        code: 'fetch-labs-failed',
      );
    }
  }

  Stream<List<LabModel>> getLabsStream(String userId) {
    return labService.getLabsStream(userId);
  }

  Future<void> updateLab(LabModel lab) async {
    try {
      await labService.updateLab(lab);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update lab',
        code: 'update-lab-failed',
      );
    }
  }

  Future<void> deleteLab(String userId, String labId) async {
    try {
      await labService.deleteLab(userId, labId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete lab',
        code: 'delete-lab-failed',
      );
    }
  }

  Future<bool> labExists(String userId, String labId) async {
    try {
      return await labService.labExists(userId, labId);
    } catch (e) {
      return false;
    }
  }
}
