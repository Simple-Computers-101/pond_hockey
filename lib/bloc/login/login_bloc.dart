import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';
import 'package:pond_hockey/bloc/login/login_state.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
//  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
  }) : assert(userRepository != null);

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
        //   yield LoginState.initial(isSignUp: false);
        yield LoginState.success();
      } on Exception catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage, isSignUp: false);
        }
      }
    }

    if (event is AppleLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final user = await userRepository
            .signInWithCredentials(event.authCredential, email: event.email);
        await addUserInfoToFireStore(user);
        yield LoginState.success();
      } on Exception catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage, isSignUp: false);
        }
      }
    }
    if (event is EmailLoginButtonPressed) {
      yield LoginState.loading();
      try {
        final user = await userRepository.signInWithEmailAndPassword(
            event.email, event.password);
        if (await user.isEmailVerified) {
          yield LoginState.success();
        } else {
          await user.sendEmailVerification();
          yield LoginState.unverified(user);
        }

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage, isSignUp: false);
        }
      }
    }

    if (event is SignUpButtonPressed) {
      try {
        await addUserInfoToFireStore(event.user);
        yield LoginState.success();

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage, isSignUp: true);
        }
      }
    }

    if (event is SignUpInitial) {
      yield LoginState.loading();
      try {
        final user =
            await userRepository.signUpWithEmail(event.email, event.password);
        await user.sendEmailVerification();
        yield LoginState.unverified(user);
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        var errorMessage = _errorMessage(error);
        if (errorMessage != null) {
          yield LoginState.failure(error: errorMessage, isSignUp: true);
        }
      }
    }

    if (event is ToggleUiButtonPressed) {
      yield LoginState.initial(isSignUp: event.isSignUp);
    }
  }

  Future<void> signInWithGoogle() async {
    final googleSignInAccount = await userRepository.googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    add(GoogleLoginButtonPressed(credential));
  }

  Future<void> signInWithApple(
      {List<Scope> scopes = const [Scope.email]}) async {
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        add(AppleLoginButtonPressed(credential, appleIdCredential.email));
        break;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
        break;

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
        break;
    }
  }

  Future<FirebaseUser> currentUser() async {
    return await userRepository.currentUser();
  }

  Future<FirebaseAuth> getAuthInstance() async {
    return await userRepository.getAuthInstance();
  }

  Future<void> addUserInfoToFireStore(FirebaseUser currentUser) async {
    return Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .setData(
      {
        'email': currentUser.email,
        'uid': currentUser.uid,
        'coins': 0,
      },
    );
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
        errorMessage =
            error.code == null ? "An undefined Error happened." : error.code;
    }
    return errorMessage;
  }
}
