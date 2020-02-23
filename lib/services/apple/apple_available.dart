import 'package:apple_sign_in/apple_sign_in.dart';

class AppleSignInAvailable {
  AppleSignInAvailable({this.isAvailable});
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    var available = await AppleSignIn.isAvailable();
    return AppleSignInAvailable(isAvailable: available);
  }
}