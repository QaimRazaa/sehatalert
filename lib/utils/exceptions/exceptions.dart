
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({required this.message, required this.code});

  @override
  String toString() => message;
}

class AuthExceptionHandler {
  static AuthException handleFirebaseAuthException(String code) {
    switch (code) {
      case 'email-already-in-use':
        return AuthException(
          message: 'This email is already registered. Please sign in instead.',
          code: code,
        );
      case 'invalid-email':
        return AuthException(
          message: 'The email address is not valid. Please check and try again.',
          code: code,
        );
      case 'operation-not-allowed':
        return AuthException(
          message: 'Email/password accounts are not enabled. Please contact support.',
          code: code,
        );
      case 'weak-password':
        return AuthException(
          message: 'Your password is too weak. Please use a stronger password.',
          code: code,
        );
      case 'user-disabled':
        return AuthException(
          message: 'This account has been disabled. Please contact support.',
          code: code,
        );
      case 'user-not-found':
        return AuthException(
          message: 'No account found with this email. Please sign up first.',
          code: code,
        );
      case 'wrong-password':
        return AuthException(
          message: 'Incorrect password. Please try again.',
          code: code,
        );
      case 'invalid-credential':
        return AuthException(
          message: 'Invalid credentials. Please check your email and password.',
          code: code,
        );
      case 'too-many-requests':
        return AuthException(
          message: 'Too many unsuccessful attempts. Please try again later.',
          code: code,
        );
      case 'network-request-failed':
        return AuthException(
          message: 'Network error. Please check your internet connection.',
          code: code,
        );
      case 'requires-recent-login':
        return AuthException(
          message: 'This operation requires recent authentication. Please sign in again.',
          code: code,
        );
      default:
        return AuthException(
          message: 'An unexpected error occurred. Please try again.',
          code: code,
        );
    }
  }
}

class FirestoreException implements Exception {
  final String message;
  final String code;

  FirestoreException({required this.message, required this.code});

  @override
  String toString() => message;
}

class FirestoreExceptionHandler {
  static FirestoreException handleFirestoreException(String code) {
    switch (code) {
      case 'permission-denied':
        return FirestoreException(
          message: 'You do not have permission to access this data.',
          code: code,
        );
      case 'not-found':
        return FirestoreException(
          message: 'The requested document was not found.',
          code: code,
        );
      case 'already-exists':
        return FirestoreException(
          message: 'The document already exists.',
          code: code,
        );
      case 'unavailable':
        return FirestoreException(
          message: 'Service temporarily unavailable. Please try again.',
          code: code,
        );
      case 'deadline-exceeded':
        return FirestoreException(
          message: 'Operation timed out. Please try again.',
          code: code,
        );
      default:
        return FirestoreException(
          message: 'A database error occurred. Please try again.',
          code: code,
        );
    }
  }
}