import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';
import 'package:pond_hockey/components/form/background.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key, this.orientation}) : super(key: key);

  final Orientation orientation;

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const defaultDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      border: InputBorder.none,
    );

    return Container(
      width: widget.orientation == Orientation.portrait
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.5,
      child: FormBuilder(
        key: _formKey,
        child: FormBackground(
          bottom: <Widget>[
            SizedBox(height: 24.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC84E89),
                    Color(0xFFF15F79),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  splashColor: Colors.white.withOpacity(0.05),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      _onLoginButtonPressed();
                    }
                  },
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          fields: <Widget>[
            Column(
              children: <Widget>[
                FormFieldBackground(
                  field: FormBuilderTextField(
                    attribute: 'email-sign_in',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: defaultDecoration.copyWith(hintText: 'Email'),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                ),
                FormFieldBackground(
                  bottom: true,
                  field: FormBuilderTextField(
                    attribute: 'password-sign_in',
                    controller: _passwordController,
                    obscureText: true,
                    maxLines: 1,
                    decoration: defaultDecoration.copyWith(
                      hintText: 'Password',
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(EmailLoginButtonPressed(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    ));
  }
}
