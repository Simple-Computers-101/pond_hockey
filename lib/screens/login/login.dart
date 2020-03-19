import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/screens/login/login_body.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login / Sign up',
        transparentBackground: true,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider<LoginBloc>(
        create: (blocContext) {
          return LoginBloc(
            userRepository: UserRepository(),
          );
        },
        child: LoginBody(),
      ),
    );
  }
}
