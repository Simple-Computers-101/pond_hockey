import 'package:cloud_firestore/cloud_firestore.dart';
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
  LoginState get initialState => LoginState.initial(isSignUp: false);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GoogleLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final user =
            await userRepository.signInWithCredentials(event.authCredential);
        await addUserInfoToFireStore(user);
        authenticationBloc.add(LoggedIn(token: user.uid));
        yield LoginState.initial(isSignUp: false);
      } on Exception catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage,isSignUp: false);
        }
      }
    }
    if (event is EmailLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final user = await userRepository.signInWithEmailAndPassword(
            event.email, event.password);
        await addUserInfoToFireStore(user);
        authenticationBloc.add(LoggedIn(token: user.uid));
        yield LoginState.initial(isSignUp: false);
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage,isSignUp: false);
        }
      }
    }

    if (event is SignUpButtonPressed) {
      yield LoginState.loading();
      try {
        final user =
            await userRepository.signUpWithEmail(event.email, event.password);
        await addUserInfoToFireStore(user);
        authenticationBloc.add(LoggedIn(token: user.uid));
        yield LoginState.initial(isSignUp: true);
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage,isSignUp: true);
        }
      }
    }

    if (event is ToggleUiButtonPressed){
      yield LoginState.initial(isSignUp: event.isSignUp);
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

  Future<void> addUserInfoToFireStore(FirebaseUser currentUser) async {
    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .setData({
      'email': currentUser.email,
      'uid': currentUser.uid,
    });
  }


  String _errorMessage(error) {
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
    return errorMessage;
  }
}
