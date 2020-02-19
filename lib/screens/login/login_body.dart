import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_state.dart';
import 'package:pond_hockey/screens/login/login_form.dart';

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (blocContext, state) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
              ),
            );
          });
        }

        if (state is LoginInitial) {
          if (!state.isInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.popUntil(context, (route) {
                return route.settings.name == "/";
              });
            });
          }
        }

        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF757F9A),
                      Color(0xFFD7DDE8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LoginForm(state: state),
                        Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                          indent: 5,
                          endIndent: 5,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Or sign in with these providers',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _GoogleSignInButton(
                              onPressed: () {
                                try {
                                  BlocProvider.of<LoginBloc>(context)
                                      .signInWithGoogle();
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
                            _AppleSignInButton(
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF757F9A),
                      Color(0xFFD7DDE8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            LoginForm(state: state),
                            Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      indent: 30,
                      endIndent: 30,
                      thickness: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Or sign in with these providers',
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          _GoogleSignInButton(
                            onPressed: () {
                              try {
                                BlocProvider.of<LoginBloc>(context)
                                    .signInWithGoogle();
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
                          _AppleSignInButton(
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
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

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      height: 50,
      width: 150,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/img/google.png',
                  width: 30,
                  height: 50,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Center(
                  child: Text('Google'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/img/apple.png',
                width: 30,
                height: 50,
              ),
              Text('Apple')
            ],
          ),
        ),
      ),
    );
  }
}