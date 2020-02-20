import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

class AuthenticationState extends Union4Impl<UnAuthenticated, Authenticated,
    AuthUninitialized, AuthLoading> {
  static final unions = const Quartet<UnAuthenticated, Authenticated,
      AuthUninitialized, AuthLoading>();
  AuthenticationState._(
      Union4<UnAuthenticated, Authenticated, AuthUninitialized, AuthLoading>
          union)
      : super(union);

  factory AuthenticationState.unAuthenticated() =>
      AuthenticationState._(unions.first(UnAuthenticated()));

  factory AuthenticationState.authenticated() =>
      AuthenticationState._(unions.second(Authenticated()));

  factory AuthenticationState.unInitialized() =>
      AuthenticationState._(unions.third(AuthUninitialized()));

  factory AuthenticationState.loading() =>
      AuthenticationState._(unions.fourth(AuthLoading()));
}

class UnAuthenticated {}

class Authenticated {}

class AuthUninitialized {}

class AuthLoading {}
