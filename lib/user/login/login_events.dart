import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();
}

class GoogleLoginButtonPressed extends LoginEvent {
  final AuthCredential authCredential;

  GoogleLoginButtonPressed(this.authCredential);

  @override
  List<Object> get props => [authCredential];

  @override
  String toString() =>
      'GoogleLoginButtonPressed { authCredential: $authCredential }';
}

class AppleLoginButtonPressed extends LoginEvent {
  final AuthCredential authCredential;

  AppleLoginButtonPressed(this.authCredential);

  @override
  List<Object> get props => [authCredential];

  @override
  String toString() =>
      'AppleLoginButtonPressed { authCredential: $authCredential }';
}