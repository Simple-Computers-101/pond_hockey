import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final String email;

  AppleLoginButtonPressed(this.authCredential, this.email);

  @override
  List<Object> get props => [authCredential, email];

  @override
  String toString() =>
      'AppleLoginButtonPressed { authCredential: $authCredential, '
      'email: $email}';
}

class EmailLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  EmailLoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'EmailLoginButtonPressed { email: $email, password: $password }';
}

class SignUpButtonPressed extends LoginEvent {
  final FirebaseUser user;

  SignUpButtonPressed(
      {@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'SignUpButtonPressed { user: $user }';
}

class ToggleUiButtonPressed extends LoginEvent {
  final bool isSignUp;
  ToggleUiButtonPressed({this.isSignUp});


}

class SignUpInitial extends LoginEvent {
  final String email;
  final String password;

  SignUpInitial({
    this.email,
    this.password,}
  );


  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'SignUpInitial { email: $email, password: $password }';
}
