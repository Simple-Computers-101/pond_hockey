import 'package:flutter/material.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_state.dart';
import 'package:pond_hockey/components/loading/loading.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SealedBlocBuilder4<AuthenticationBloc, AuthenticationState,
        UnAuthenticated, Authenticated, AuthUninitialized, AuthLoading>(
      builder: (_, states) {
        return states(
          (unAuthenticated) => HomeScreen(),
          (authenticated) => HomeScreen(),
          (unInitialized) => LoadingScreen(),
          (loading) => LoadingScreen(),
        );
      },
    );
  }
}
