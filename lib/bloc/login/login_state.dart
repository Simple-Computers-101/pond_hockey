import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

class LoginState extends Union3Impl<LoginInitial, LoginLoading, LoginFailure> {
  static final unions =
      const Triplet<LoginInitial, LoginLoading, LoginFailure>();

  LoginState._(Union3<LoginInitial, LoginLoading, LoginFailure> union)
      : super(union);

  factory LoginState.initial({bool isSignUp}) => LoginState._(
        unions.first(
          LoginInitial(isSignUp: isSignUp),
        ),
      );

  factory LoginState.loading() => LoginState._(unions.second(LoginLoading()));

  factory LoginState.failure({String error,bool isSignUp}) => LoginState._(
        unions.third(
          LoginFailure(error: error,isSignUp: isSignUp),
        ),
      );
}

class LoginInitial {
  final bool isSignUp;

  LoginInitial({this.isSignUp});
}

class LoginLoading {}

class LoginFailure {
  final bool isSignUp;
  final String error;

  LoginFailure({this.error,this.isSignUp});

  @override
  String toString() => 'LoginFailure { error: $error }';
}
