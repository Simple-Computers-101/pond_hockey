import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isProcessing = false;
  final _formKey = GlobalKey<FormState>();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  decoration: InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                ),
              ),
            ),
            RaisedButton(
                child: Text("Reset"),
                onPressed: isProcessing
                    ? null
                    : () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        setState(() {
                          isProcessing = true;
                        });
                        BlocProvider.of<LoginBloc>(context)
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
    super.dispose();
  }
}
