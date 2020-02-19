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

  AppleLoginButtonPressed(this.authCredential);

  @override
  List<Object> get props => [authCredential];

  @override
  String toString() =>
      'AppleLoginButtonPressed { authCredential: $authCredential }';
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