import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithCredential(AuthCredential credential) async {
    return _auth.signInWithCredential(credential);
  }

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }
}
