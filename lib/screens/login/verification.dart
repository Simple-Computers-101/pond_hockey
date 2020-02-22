import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';

class EmailVerification extends StatelessWidget {
  EmailVerification(this.user);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text(user.email),
        onPressed: () async {
          try {
            final userInfo = UserUpdateInfo();
            userInfo.displayName = "test";
            user.updateProfile(userInfo).then((value) async {
              if (await user.isEmailVerified) {
                await BlocProvider.of<LoginBloc>(context)
                    .add(SignUpButtonPressed(user: user));
              } else {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please verify email first"),
                  ),
                );
              }
            });
          } on Exception catch (error) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            );
          }
        },
      ),
    );
  }
}
