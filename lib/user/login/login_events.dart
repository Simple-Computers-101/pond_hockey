import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final AuthCredential authCredential;

  LoginButtonPressed(this.authCredential);

  @override
  List<Object> get props => [authCredential];

  @override
  String toString() =>
      'LoginButtonPressed { authCredential: $authCredential }';
}