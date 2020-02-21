import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';

class CreateAccountForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountFormState();
  }
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
              ),
              TextField(
                controller: _passwordController,
              ),
              TextField(
                controller: _confirmPasswordController,
              ),
              RaisedButton(
                child: Text('Sign Up'),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(SignUpButtonPressed(
                      email: _emailController.text,
                      password: _passwordController.text));
                },
              ),
              FlatButton(
                child: Text('Sign In instead'),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(ToggleUiButtonPressed(isSignUp: false));
                },
              ),
            ],
          ),
        ));
  }
}
