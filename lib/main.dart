import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:pond_hockey/services/email/email_helper.dart';
import 'package:pond_hockey/theme/style.dart';

void main() {
  EmailHelper().start();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (blocContext) {
        return AuthenticationBloc(
          userRepository: UserRepository(),
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pond Hockey',
        theme: Style().lightTheme,
        navigatorKey: Router.navigator.key,
        onGenerateRoute: Router.onGenerateRoute,
        initialRoute: Router.init,
      ),
    );
  }
}
