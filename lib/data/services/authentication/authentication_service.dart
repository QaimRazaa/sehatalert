import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/exceptions/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => firebaseAuth.currentUser;

  // Get current user ID
  String get currentUserId => firebaseAuth.currentUser?.uid ?? '';

  // Check if user is authenticated
  bool get isAuthenticated => firebaseAuth.currentUser != null;

  // Auth state changes stream
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign up', code: 'unknown');
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign in', code: 'unknown');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign out', code: 'unknown');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to send password reset email', code: 'unknown');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to delete account', code: 'unknown');
    }
  }

  // Update email
  Future<void> updateEmail({required String newEmail}) async {
    try {
      await firebaseAuth.currentUser?.verifyBeforeUpdateEmail(newEmail.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to update email', code: 'unknown');
    }
  }

  // Update password
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await firebaseAuth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to update password', code: 'unknown');
    }
  }

  // Re-authenticate user
  Future<void> reauthenticateWithCredential({required String email, required String password}) async {
    try {
      final credential = EmailAuthProvider.credential(email: email.trim(), password: password);
      await firebaseAuth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to re-authenticate', code: 'unknown');
    }
  }

  Future<void> sendOTPForPasswordReset({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw AuthException(message: 'Failed to send OTP', code: 'otp-failed');
    }
  }

  Future<void> verifyOTP({required String verificationId, required String otp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Invalid OTP', code: 'invalid-otp');
    }
  }

  Future<void> sendOTPForPhoneLogin({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw AuthException(message: 'Failed to send OTP', code: 'otp-failed');
    }
  }

  Future<void> signInWithPhoneCredential({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleFirebaseAuthException(e.code);
    } catch (e) {
      throw AuthException(message: 'Invalid OTP', code: 'invalid-otp');
    }
  }
}
