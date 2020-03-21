import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pond_hockey/bloc/auth/auth_providers.dart';
import 'package:pond_hockey/models/user.dart';

class UserRepository {
  final _authProvider = AuthProvider();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final CollectionReference ref = Firestore.instance.collection('users');

  Future<FirebaseUser> signInWithCredentials(AuthCredential credential,
      {String email}) async {
    final authResult = await _authProvider.signInWithCredential(credential);
    final user = authResult.user;
    if (email != null) {
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

  Future<FirebaseUser> currentFirebaseUser() async {
    return await _authProvider.getCurrentUser();
  }

  FirebaseAuth getAuthInstance() {
    return _authProvider.authInstance();
  }

  Future<User> getUserFromEmail(String email) async {
    var query = await ref.where('email', isEqualTo: email).getDocuments();

    return User.fromMap(query.documents.first.data);
  }

  Future<User> getUserFromUID(String uid) async {
    var query = await ref.where('uid', isEqualTo: uid).getDocuments();

    return User.fromMap(query.documents.first.data);
  }

  Future<User> getCurrentUser() async {
    var user = await currentFirebaseUser();
    if (user != null) {
      return getUserFromUID(user.uid);
    }
    return null;
  }

  Future<DocumentSnapshot> getUserDocFromUid(String uid) async {
    final userDoc = await ref.document(uid).get();
    return userDoc;
  }

  void addCredits(String userId, int creditsToAdd) {
    Firestore.instance.runTransaction((transaction) async {
      final userDoc = await transaction.get(ref.document(userId));
      await transaction.update(userDoc.reference, {
        'credits': userDoc.data['credits'] + creditsToAdd,
      });
    });
  }

  Future<void> spendCredit({String userId}) async {
    String usableUserId;
    if (userId == null) {
      usableUserId = (await getCurrentUser()).uid;
    } else {
      usableUserId = userId;
    }
    Firestore.instance.runTransaction((transaction) async {
      final userDoc = await transaction.get(ref.document(usableUserId));
      await transaction.update(userDoc.reference, {
        'credits': userDoc.data['credits'] - 1,
      });
    });
  }

  Future<void> addPaymentToHistory(String userId, dynamic info) async {
    final userDoc = ref.document(userId);
    assert(userDoc != null);
    userDoc.setData({'paymentHistory': []}, merge: true);
  }
}
