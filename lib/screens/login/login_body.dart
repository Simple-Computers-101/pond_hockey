import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/user/login/login_bloc.dart';
import 'package:pond_hockey/user/login/login_state.dart';

class LoginBody extends StatefulWidget {
  LoginBody({@required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<StatefulWidget> createState() {
    return _LoginBodyState();
  }
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (blocContext, state) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
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
                  } on Exception catch (error) {
                    widget.scaffoldKey.currentState.removeCurrentSnackBar();
                    widget.scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
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
