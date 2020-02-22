import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';
import 'package:pond_hockey/screens/login/create_account.dart';
import 'package:pond_hockey/screens/login/widgets/auth_buttons.dart';

class CreateAccountBody extends StatelessWidget {
  const CreateAccountBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (cntx, orientation) {
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      CreateAccountForm(
                        orientation: orientation,
                      ),
                      FlatButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            ToggleUiButtonPressed(isSignUp: false),
                          );
                        },
                        child: Text("Have an account? Login."),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                        indent: 5,
                        endIndent: 5,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Or sign up with these providers',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GoogleSignInButton(
                            onPressed: () async {
                              await BlocProvider.of<LoginBloc>(context)
                                  .signInWithGoogle()
                                  .catchError(
                                (error) {
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Sign up with Google failed'),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          AppleSignInButton(
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CreateAccountForm(
                          orientation: orientation,
                        ),
                        FlatButton(
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context).add(
                              ToggleUiButtonPressed(isSignUp: false),
                            );
                          },
                          child: Text("Have an account? Login."),
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
                        'Or sign up with these providers',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      GoogleSignInButton(
                        onPressed: () {
                          try {
                            BlocProvider.of<LoginBloc>(context)
                                .signInWithGoogle();
                          } on Exception {
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sign up with Google failed'),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                      ),
                      AppleSignInButton(
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
  }
}
