import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';

class EmailVerification extends StatefulWidget {
  EmailVerification(this.user);
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    return _EmailVerificationState();
  }
}

class _EmailVerificationState extends State<EmailVerification> {
  var isVerifying = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: Text("Check Status"),
            onPressed: isVerifying
                ? () {}
                : () async {
                    setState(() {
                      isVerifying = true;
                    });
                    try {
                      final currentUser =
                          await BlocProvider.of<LoginBloc>(context)
                              .currentUser();
                      if (await currentUser.isEmailVerified) {
                        await BlocProvider.of<LoginBloc>(context)
                            .add(SignUpButtonPressed(user: currentUser));
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Your email needs verification"),
                          ),
                        );

                        setState(() {
                          isVerifying = false;
                        });
                      }
                    } on Exception catch (error) {
                      Scaffold.of(context).removeCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                      setState(() {
                        isVerifying = false;
                      });
                    }
                  },
          ),
          isVerifying ? CircularProgressIndicator() : SizedBox.shrink(),
        ],
      ),
    );
  }
}
