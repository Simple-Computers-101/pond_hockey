import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/screens/login/login_body.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login / Sign up',
        transparentBackground: true,
//        actions: <Widget>[
//          FlatButton(
//              onPressed: () {
//                BlocProvider.of<AuthenticationBloc>(context)
//                    .add(LogInLater());
//              },
//              child: Text("Later"))
//        ],
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      body: BlocProvider<LoginBloc>(
        create: (blocContext) {
          return LoginBloc(
            userRepository: Provider.of<UserRepository>(context),
            authenticationBloc:
                BlocProvider.of<AuthenticationBloc>(blocContext),
          );
        },
        child: LoginBody(),
      ),
    );
  }
}
