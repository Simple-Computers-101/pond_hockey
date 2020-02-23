import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword(this.loginContext);
  final BuildContext loginContext;
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordState();
  }
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
            ),
            RaisedButton(
                child: Text("Reset"),
                onPressed: isProcessing
                    ? null
                    : () async {
                        setState(() {
                          isProcessing = true;
                        });
                        BlocProvider.of<LoginBloc>(widget.loginContext)
                            .getAuthInstance()
                            .then((auth) async {
                          await auth
                              .sendPasswordResetEmail(
                                  email: _emailController.text)
                              .then((value) {
                            _scaffoldKey.currentState.removeCurrentSnackBar();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Reset email sent"),
                              ),
                            );
                            setState(() {
                              isProcessing = false;
                            });
                          }).catchError((error) {
                            _scaffoldKey.currentState.removeCurrentSnackBar();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                            setState(() {
                              isProcessing = false;
                            });
                          });
                        }).catchError((error) {
                          _scaffoldKey.currentState.removeCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                          setState(() {
                            isProcessing = true;
                          });
                        });
                      }),
            isProcessing ? CircularProgressIndicator() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
