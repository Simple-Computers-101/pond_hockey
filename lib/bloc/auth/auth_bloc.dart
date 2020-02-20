import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/bloc/auth/auth_events.dart';
import 'package:pond_hockey/bloc/auth/auth_state.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null) {
    add(AppStarted());
  }

  @override
  AuthenticationState get initialState => AuthenticationState.unInitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationState.authenticated();
      } else {
        yield AuthenticationState.unAuthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationState.loading();
      await userRepository.persistToken(event.token);
      yield AuthenticationState.authenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationState.loading();
      await userRepository.deleteToken();
      yield AuthenticationState.unAuthenticated();
    }
  }
}
