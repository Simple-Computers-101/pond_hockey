import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

class LoginState extends Union3Impl<LoginInitial, LoginLoading, LoginFailure> {
  static final unions =
      const Triplet<LoginInitial, LoginLoading, LoginFailure>();

  LoginState._(Union3<LoginInitial, LoginLoading, LoginFailure> union)
      : super(union);

  factory LoginState.initial({bool isInitial}) => LoginState._(
        unions.first(
          LoginInitial(),
        ),
      );

  factory LoginState.loading() => LoginState._(unions.second(LoginLoading()));

  factory LoginState.failure({String error}) => LoginState._(
        unions.third(
          LoginFailure(error: error),
        ),
      );
}

class LoginInitial {}

class LoginLoading {}

class LoginFailure {
  final String error;

  LoginFailure({this.error});

  @override
  String toString() => 'LoginFailure { error: $error }';
}
