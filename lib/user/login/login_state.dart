import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final bool isInitial;
  LoginInitial({@required this.isInitial});
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}