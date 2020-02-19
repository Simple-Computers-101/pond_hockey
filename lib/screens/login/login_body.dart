import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_state.dart';
import 'package:pond_hockey/screens/login/email/email_login.dart';

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (blocContext, state) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GoogleSignInButton(
                onPressed: () {
                  try {
                    BlocProvider.of<LoginBloc>(context).signInWithGoogle();
                  } on Exception {
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occured'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              AppleSignInButton(
                onPressed: () {},
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmailLoginScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: Icon(Icons.email),
                label: Text("Sign in with Email"),
              )
            ],
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
