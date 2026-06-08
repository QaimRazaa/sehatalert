// lib/data/services/user_firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/user/user_model.dart';

class UserFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String usersCollection = 'users';

  // Create user document in Firestore
  Future<void> createUser(UserModel user) async {
    try {
      print('Attempting to create user with UID: ${user.uid}');
      print('Collection: $usersCollection');
      print('User data: ${user.toMap()}');

      await firestore.collection(usersCollection).doc(user.uid).set(user.toMap());

      print('User created successfully in Firestore');
    } on FirebaseException catch (e) {
      print('FirebaseException Code: ${e.code}');
      print('FirebaseException Message: ${e.message}');
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      print('Unknown Error: $e');
      throw FirestoreException(message: 'Failed to create user profile', code: 'unknown');
    }
  }

  // Get user document from Firestore
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await firestore.collection(usersCollection).doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to retrieve user profile', code: 'unknown');
    }
  }

  // Update user document in Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.now();
      await firestore.collection(usersCollection).doc(uid).update(data);
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update user profile', code: 'unknown');
    }
  }

  // Delete user document from Firestore
  Future<void> deleteUser(String uid) async {
    try {
      await firestore.collection(usersCollection).doc(uid).delete();
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete user profile', code: 'unknown');
    }
  }

  // Check if user exists
  Future<bool> userExists(String uid) async {
    try {
      final doc = await firestore.collection(usersCollection).doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to check user existence', code: 'unknown');
    }
  }

  // Get user stream for real-time updates
  Stream<UserModel?> getUserStream(String uid) {
    try {
      return firestore.collection(usersCollection).doc(uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return UserModel.fromMap(doc.data()!);
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to get user stream', code: 'unknown');
    }
  }

  // Update specific user fields
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await firestore.collection(usersCollection).doc(uid).update({field: value, 'updatedAt': Timestamp.now()});
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update user field', code: 'unknown');
    }
  }

  Future<bool> userExistsByPhone(String phoneNumber) async {
    try {
      final query = await firestore
          .collection(usersCollection)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to check user by phone', code: 'unknown');
    }
  }

  Future<UserModel?> getUserByPhone(String phoneNumber) async {
    try {
      final query = await firestore
          .collection(usersCollection)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      if (query.docs.isEmpty) return null;
      return UserModel.fromMap(query.docs.first.data());
    } on FirebaseException catch (e) {
      throw FirestoreExceptionHandler.handleFirestoreException(e.code);
    } catch (e) {
      throw FirestoreException(message: 'Failed to get user by phone', code: 'unknown');
    }
  }

  Future<void> updatePasswordByPhone(String phoneNumber, String newPassword) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw FirestoreException(message: 'User not found', code: 'user-not-found');
      }

      // Update password in Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      rethrow;
    }
  }
}
