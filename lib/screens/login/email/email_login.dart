import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/screens/login/email/email_login_body.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with email address'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (blocContext) {
          return LoginBloc(
            userRepository: Provider.of<UserRepository>(context),
            authenticationBloc:
                BlocProvider.of<AuthenticationBloc>(blocContext),
          );
        },
        child: EmailLoginBody(),
      ),
    );
  }
}
