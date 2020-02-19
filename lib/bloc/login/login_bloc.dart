import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_events.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';
import 'package:pond_hockey/bloc/login/login_state.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial(isInitial: true);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GoogleLoginButtonPressed) {
      yield LoginLoading();
      try {
        final token =
            await userRepository.signInWithCredentials(event.authCredential);

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial(isInitial: false);
      } on Exception catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
    if (event is EmailLoginButtonPressed) {
      yield LoginLoading();
      try {
        final token = await userRepository.signInWithEmailAndPassword(
            event.email, event.password);

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial(isInitial: false);
      } on Exception catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }

  Future<AuthCredential> signInWithGoogle() async {
    final googleSignInAccount = await userRepository.googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    add(GoogleLoginButtonPressed(credential));

    return credential;
  }
}
