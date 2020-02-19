import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/screens/login/email/email_login_body.dart';
import 'package:pond_hockey/user/auth/auth_bloc.dart';
import 'package:pond_hockey/user/login/login_bloc.dart';
import 'package:pond_hockey/user/user_repository.dart';

class EmailLoginScreen extends StatelessWidget{
  final UserRepository userRepository;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  EmailLoginScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login with email address'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (blocContext) {
          return LoginBloc(
              userRepository: userRepository,
              authenticationBloc:
              BlocProvider.of<AuthenticationBloc>(blocContext));
        },
        child: EmailLoginBody(scaffoldKey: _scaffoldKey,),
      ),
    );
  }

}