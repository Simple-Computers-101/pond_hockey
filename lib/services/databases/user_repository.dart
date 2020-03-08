import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pond_hockey/bloc/auth/auth_providers.dart';

class UserRepository {
  final _authProvider = AuthProvider();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<FirebaseUser> signInWithCredentials(AuthCredential credential,
      {String email}) async {
    final authResult = await _authProvider.signInWithCredential(credential);
    final user = authResult.user;
    if (email != null){
      await user.updateEmail(email);
    }
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final currentUser = await _authProvider.getCurrentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult =
        await _authProvider.signInWithEmailAndPassword(email, password);
    final user = authResult.user;

    assert(!user.isAnonymous);
//    assert(user.isEmailVerified);

    final currentUser = await _authProvider.getCurrentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  Future<FirebaseUser> signUpWithEmail(String email, String password) async {
    final authResult = await _authProvider.signUpWithEmail(email, password);
    final user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final currentUser = await _authProvider.getCurrentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  Future<FirebaseUser> currentUser() async {
    return await _authProvider.getCurrentUser();
  }

  FirebaseAuth getAuthInstance(){
    return _authProvider.authInstance();
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
