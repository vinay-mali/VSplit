import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String message;
        switch (e.code) {
          case 'invalid-email':
            message = "Please enter a valid email address.";
            break;
          case 'too-many-requests':
            message = "Too many attempts. Try again later.";
            break;
          case 'email-already-in-use':
            message = "An account already exists with this email";
            break;
          case 'weak-password':
            message = "Password must be at least 6 characters.";
            break;
          default:
            message = "Something went wrong. Please try again.";
        }
        return Future.error(message);
      }
      return Future.error("Something went wrong. Please try again");
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String message;
        switch (e.code) {
          case 'invalid-email':
            message = "Please enter a valid email address";
            break;
          case 'wrong-password':
            message = "Incorrect Password";
            break;
          case 'user-not-found':
            message = "No account found";
            break;
          case 'invalid-credential':
            message = "Incorrect email or password";
            break;
          case 'too-many-requests':
            message = "Too many attempts. Try again later.";
            break;
          default:
            message = "Something went wrong. Please try again.";
        }
        return Future.error(message);
      }
      return Future.error("Something went wrong. Please try again.");
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw "Unable to Log out";
    }
  }
}
