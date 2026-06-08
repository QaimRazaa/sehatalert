// lib/data/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../model/user/user_model.dart';
import '../../services/authentication/authentication_service.dart';
import '../../services/user/user_service.dart';

class AuthRepository {
  final FirebaseAuthService authService = FirebaseAuthService();
  final UserFirestoreService firestoreService = UserFirestoreService();
  final SharedPreferencesService prefsService = SharedPreferencesService();

  // Get current user
  User? get currentUser => authService.currentUser;

  // Get current user ID — prefers session UID (set after phone login) over Firebase UID
  String get currentUserId => authService.currentUserId;

  // Check if user is authenticated
  bool get isAuthenticated => authService.isAuthenticated;

  // Auth state changes stream
  Stream<User?> get authStateChanges => authService.authStateChanges;

  // Sign up with email and password
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await authService.signUpWithEmailAndPassword(email: email, password: password);

      // Create user model
      final user = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName.trim(),
        email: email.trim(),
        phoneNumber: phoneNumber.trim(),
        createdAt: DateTime.now(),
      );

      // Save user data to Firestore
      await firestoreService.createUser(user);

      return user;
    } on AuthException {
      rethrow;
    } on FirestoreException {
      // If Firestore save fails, delete the auth user
      await authService.deleteAccount();
      rethrow;
    } catch (e) {
      // If anything fails, clean up auth user
      await authService.deleteAccount();
      throw AuthException(message: 'Failed to create account. Please try again.', code: 'signup-failed');
    }
  }

  // Sign in with email and password
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await authService.signInWithEmailAndPassword(email: email, password: password);

      // Get user data from Firestore
      final user = await firestoreService.getUser(userCredential.user!.uid);

      if (user == null) {
        throw AuthException(message: 'User profile not found. Please contact support.', code: 'profile-not-found');
      }

      return user;
    } on AuthException {
      rethrow;
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'Failed to sign in. Please try again.', code: 'signin-failed');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await authService.signOut();
      await prefsService.clearSessionUserId();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out. Please try again.', code: 'signout-failed');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await authService.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (!isAuthenticated) return null;
      return await firestoreService.getUser(currentUserId);
    } catch (e) {
      throw FirestoreException(message: 'Failed to retrieve user data', code: 'get-user-failed');
    }
  }

  // Update user profile with patient information
  Future<void> updatePatientInfo(PatientInfo patientInfo) async {
    try {
      if (!isAuthenticated) {
        throw AuthException(message: 'User not authenticated', code: 'not-authenticated');
      }

      await firestoreService.updateUser(currentUserId, {'patientInfo': patientInfo.toMap()});
    } catch (e) {
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      if (!isAuthenticated) {
        throw AuthException(message: 'User not authenticated', code: 'not-authenticated');
      }

      // Delete Firestore data first
      await firestoreService.deleteUser(currentUserId);

      // Then delete auth account
      await authService.deleteAccount();
    } catch (e) {
      throw AuthException(message: 'Failed to delete account. Please try again.', code: 'delete-account-failed');
    }
  }

  // Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    try {
      return await firestoreService.userExists(uid);
    } catch (e) {
      return false;
    }
  }

  // Get user stream for real-time updates
  Stream<UserModel?> getUserStream() {
    if (!isAuthenticated) {
      return Stream.value(null);
    }
    return firestoreService.getUserStream(currentUserId);
  }

  // Add this method to your AuthRepository class
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await firestoreService.updateUserField(uid, field, value);
    } catch (e) {
      rethrow;
    }
  }

  // Add to lib/data/repositories/auth_repository.dart

  Future<void> sendOTPForPasswordReset({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await authService.sendOTPForPasswordReset(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onVerificationFailed: onVerificationFailed,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOTP({required String verificationId, required String otp}) async {
    try {
      await authService.verifyOTP(verificationId: verificationId, otp: otp);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({required String phoneNumber, required String newPassword}) async {
    try {
      await firestoreService.updatePasswordByPhone(phoneNumber, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInWithPhone({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final user = await firestoreService.getUserByPhone(phoneNumber);
      if (user == null) {
        throw AuthException(
          message: 'No account found with this number. Please register first.',
          code: 'user-not-found',
        );
      }

      final userCredential = await authService.signInWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final freshUser = await firestoreService.getUser(userCredential.user!.uid);
      if (freshUser == null) {
        throw AuthException(message: 'User profile not found.', code: 'profile-not-found');
      }

      return freshUser;
    } on AuthException {
      rethrow;
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'Failed to sign in. Please try again.', code: 'signin-failed');
    }
  }
}
