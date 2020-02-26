import 'package:firebase_auth/firebase_auth.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

class LoginState extends Union5Impl<LoginInitial, LoginLoading, LoginFailure,
    LoginUnverified, LoginSuccess> {
  static final unions = const Quintet<LoginInitial, LoginLoading, LoginFailure,
      LoginUnverified, LoginSuccess>();

  LoginState._(
      Union5<LoginInitial, LoginLoading, LoginFailure, LoginUnverified,
              LoginSuccess>
          union)
      : super(union);

  factory LoginState.initial({bool isSignUp}) => LoginState._(
        unions.first(
          LoginInitial(isSignUp: isSignUp),
        ),
      );

  factory LoginState.loading() => LoginState._(unions.second(LoginLoading()));

  factory LoginState.failure({String error, bool isSignUp}) => LoginState._(
        unions.third(
          LoginFailure(error: error, isSignUp: isSignUp),
        ),
      );

  factory LoginState.unverified(FirebaseUser user) => LoginState._(
        unions.fourth(
          LoginUnverified(user),
        ),
      );
  factory LoginState.success() => LoginState._(
        unions.fifth(
          LoginSuccess(),
        ),
      );
}

class LoginInitial {
  final bool isSignUp;

  LoginInitial({this.isSignUp});
}

class LoginLoading {}

class LoginUnverified {
  final FirebaseUser user;
  LoginUnverified(this.user);
}

class LoginFailure {
  final bool isSignUp;
  final String error;

  LoginFailure({this.error, this.isSignUp});

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class LoginSuccess {}
