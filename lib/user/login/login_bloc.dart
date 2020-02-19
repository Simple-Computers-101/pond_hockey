import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/user/auth/auth_bloc.dart';
import 'package:pond_hockey/user/auth/auth_events.dart';
import 'package:pond_hockey/user/login/login_events.dart';
import 'package:pond_hockey/user/login/login_state.dart';
import 'package:pond_hockey/user/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
//        final token = await userRepository.signInWithCredential(event.authCredential);

       // authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } on Exception catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}