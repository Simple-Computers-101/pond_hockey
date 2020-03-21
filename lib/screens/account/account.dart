import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/router/router.gr.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _editingMode = false;
  bool _verifiedEmail = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEmailVerified();
  }

  void isEmailVerified() async {
    var user = await FirebaseAuth.instance.currentUser();
    _emailController.text = user.email;
    setState(() {
      _verifiedEmail = user.isEmailVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _editingMode = !_editingMode;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FormBuilder(
                // readOnly: true,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  primary: false,
                  shrinkWrap: true,
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: 'account-email',
                      readOnly: !_editingMode,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        helperText: _verifiedEmail
                            ? 'Email is verified'
                            : 'Verify your email',
                        helperStyle: TextStyle(
                          color: _verifiedEmail ? Colors.green : Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validators: [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Router.navigator.popUntil(ModalRoute.withName('/'));
                  });
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
