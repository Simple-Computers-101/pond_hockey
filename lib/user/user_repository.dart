import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pond_hockey/user/auth/auth_providers.dart';

class UserRepository {
  final _authProvider = AuthProvider();

//  Future<String> signInWithCredential(AuthCredential credential) async {
//    final authResult = await _authProvider.signInWithCredential(credential);
//    if (authResult.user.uid == null) {
//      throw Exception(authResult.toString());
//    }
//    return authResult.user.uid;
//  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    final flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.delete(key: 'token');
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    final flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: 'token', value: token);
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    var token = await FlutterSecureStorage().read(key: 'token');
    return token == null ? false : true;
  }
}