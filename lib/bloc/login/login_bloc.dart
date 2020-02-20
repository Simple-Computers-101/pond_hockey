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
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GoogleLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final token =
            await userRepository.signInWithCredentials(event.authCredential);

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginState.initial();
      } on Exception catch (error) {
        yield LoginState.failure(error: error.toString());
      }
    }
    if (event is EmailLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final token = await userRepository.signInWithEmailAndPassword(
            event.email, event.password);

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginState.initial();
      // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        String errorMessage;
        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage);
        }
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
