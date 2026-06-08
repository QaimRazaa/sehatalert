import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/contacts/contact_model.dart';

class ContactService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createContact(ContactModel contact) async {
    try {
      await firestore
          .collection('users')
          .doc(contact.userId)
          .collection('contacts')
          .doc(contact.id)
          .set(contact.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to create contact: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to create contact', code: 'create-contact-failed');
    }
  }

  Future<List<ContactModel>> getContactsByType(String userId, String type) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .where('type', isEqualTo: type)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => ContactModel.fromMap(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts', code: 'fetch-contacts-failed');
    }
  }

  Future<List<ContactModel>> getAllContacts(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => ContactModel.fromMap(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts', code: 'fetch-contacts-failed');
    }
  }

  Stream<List<ContactModel>> getContactsStream(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => ContactModel.fromMap(doc.data(), doc.id)).toList());
    } catch (e) {
      return Stream.error(FirestoreException(message: 'Failed to stream contacts', code: 'stream-contacts-failed'));
    }
  }

  Future<void> updateContact(ContactModel contact) async {
    try {
      await firestore
          .collection('users')
          .doc(contact.userId)
          .collection('contacts')
          .doc(contact.id)
          .update(contact.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to update contact: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update contact', code: 'update-contact-failed');
    }
  }

  Future<void> deleteContact(String userId, String contactId) async {
    try {
      await firestore.collection('users').doc(userId).collection('contacts').doc(contactId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: 'Failed to delete contact: ${e.message}', code: e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete contact', code: 'delete-contact-failed');
    }
  }

  Future<bool> contactExists(String userId, String contactId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).collection('contacts').doc(contactId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
