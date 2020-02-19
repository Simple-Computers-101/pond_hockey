import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/user/login/login_bloc.dart';
import 'package:pond_hockey/user/login/login_events.dart';
import 'package:pond_hockey/user/login/login_state.dart';

class EmailLoginBody extends StatefulWidget {
  EmailLoginBody({@required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<StatefulWidget> createState() {
    return _EmailLoginBodyState();
  }
}

class _EmailLoginBodyState extends State<EmailLoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (
        blocContext,
        state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            widget.scaffoldKey.currentState.removeCurrentSnackBar();
            widget.scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('${state.error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        if (state is LoginInitial) {
          if (!state.isInitial) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              Navigator.popUntil(context, (route) {
                return route.settings.name == "/";
              });
            });
          }
        }

        final logo = Hero(
          tag: 'hero',
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset('assets/img/logo.png'),
          ),
        );

        final username = TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: validateEmail,
        );

        final password = TextFormField(
          controller: _passwordController,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter password';
            } else if (value.length < 6) {
              return 'Password is short';
            }
            return null;
          },
        );

        final loginButton = Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: state is! LoginLoading
                ? () {
                    if (_formKey.currentState.validate()) {
                      _onLoginButtonPressed();
                      FocusScope.of(context).unfocus();
                    }
                  }
                : null,
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Login', style: TextStyle(color: Colors.white)),
          ),
        );

        return Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: [
                logo,
                SizedBox(height: 48.0),
                username,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                Center(
                  child: Container(
                    child: state is LoginLoading
                        ? CircularProgressIndicator()
                        : null,
                  ),
                ),
              ],
            ),
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

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(EmailLoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
