import '../../../utils/exceptions/exceptions.dart';
import '../../model/contacts/contact_model.dart';
import '../../services/contact/contact_service.dart';

class ContactRepository {
  final ContactService contactService = ContactService();

  Future<void> createContact(ContactModel contact) async {
    try {
      await contactService.createContact(contact);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to save contact', code: 'create-contact-failed');
    }
  }

  Future<List<ContactModel>> getContactsByType(String userId, String type) async {
    try {
      return await contactService.getContactsByType(userId, type);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts', code: 'fetch-contacts-failed');
    }
  }

  Future<List<ContactModel>> getAllContacts(String userId) async {
    try {
      return await contactService.getAllContacts(userId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to fetch contacts', code: 'fetch-contacts-failed');
    }
  }

  Stream<List<ContactModel>> getContactsStream(String userId) {
    return contactService.getContactsStream(userId);
  }

  Future<void> updateContact(ContactModel contact) async {
    try {
      await contactService.updateContact(contact);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to update contact', code: 'update-contact-failed');
    }
  }

  Future<void> deleteContact(String userId, String contactId) async {
    try {
      await contactService.deleteContact(userId, contactId);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete contact', code: 'delete-contact-failed');
    }
  }

  Future<bool> contactExists(String userId, String contactId) async {
    try {
      return await contactService.contactExists(userId, contactId);
    } catch (e) {
      return false;
    }
  }
}
