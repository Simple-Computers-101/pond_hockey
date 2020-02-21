import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pond_hockey/bloc/login/login_bloc.dart';
import 'package:pond_hockey/bloc/login/login_events.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({@required this.orientation});

  final Orientation orientation;

  @override
  State<StatefulWidget> createState() {
    return _CreateAccountFormState();
  }
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.07,
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
              BlocProvider.of<LoginBloc>(context).add(
                SignUpButtonPressed(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              );
            }
          },
          child: Center(
            child: Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    const defaultDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      border: InputBorder.none,
    );

    return FormBuilder(
      key: _formKey,
      autovalidate: true,
      child: Container(
        width: widget.orientation == Orientation.portrait
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20.0,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[100]),
                      ),
                    ),
                    child: FormBuilderTextField(
                      attribute: 'email-sign_up',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: defaultDecoration.copyWith(hintText: 'Email'),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[100]),
                      ),
                    ),
                    child: FormBuilderTextField(
                      attribute: 'password-sign_up',
                      controller: _passwordController,
                      obscureText: true,
                      maxLines: 1,
                      decoration:
                          defaultDecoration.copyWith(hintText: 'Password'),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FormBuilderTextField(
                      attribute: 'password-confirm',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      maxLines: 1,
                      decoration: defaultDecoration.copyWith(
                        hintText: 'Confirm Password',
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6),
                        (value) {
                          var otherPassword = _formKey.currentState
                              .fields['password-sign_up'].currentState.value;
                          if (otherPassword == value) {
                            return null;
                          }
                          return 'Passwords must match';
                        }
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
