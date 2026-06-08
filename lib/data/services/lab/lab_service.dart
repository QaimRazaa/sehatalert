import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/lab/lab_model.dart';

class LabService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createLab(LabModel lab) async {
    try {
      await firestore
          .collection('users')
          .doc(lab.userId)
          .collection('labs')
          .doc(lab.id)
          .set(lab.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to save lab: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to save lab',
        code: 'create-lab-failed',
      );
    }
  }

  Future<List<LabModel>> getAllLabs(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('labs')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => LabModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch labs: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch labs',
        code: 'fetch-labs-failed',
      );
    }
  }

  Stream<List<LabModel>> getLabsStream(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('labs')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => LabModel.fromMap(doc.data(), doc.id))
                .toList(),
          );
    } catch (e) {
      return Stream.error(
        FirestoreException(
          message: 'Failed to stream labs',
          code: 'stream-labs-failed',
        ),
      );
    }
  }

  Future<void> updateLab(LabModel lab) async {
    try {
      await firestore
          .collection('users')
          .doc(lab.userId)
          .collection('labs')
          .doc(lab.id)
          .update(lab.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update lab: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update lab',
        code: 'update-lab-failed',
      );
    }
  }

  Future<void> deleteLab(String userId, String labId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('labs')
          .doc(labId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to delete lab: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete lab',
        code: 'delete-lab-failed',
      );
    }
  }

  Future<bool> labExists(String userId, String labId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('labs')
          .doc(labId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
