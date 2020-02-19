import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/loading/loading.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:pond_hockey/theme/style.dart';
import 'package:pond_hockey/user/auth/auth_bloc.dart';
import 'package:pond_hockey/user/auth/auth_state.dart';
import 'package:pond_hockey/user/user_repository.dart';
import 'package:provider/provider.dart';

import 'screens/home/home.dart';

void main() {
  runApp(MyApp(
    userRepository: UserRepository(),
  ));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  MyApp({@required this.userRepository});
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
        return AuthenticationBloc(userRepository: widget.userRepository);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pond Hockey',
        theme: Style().lightTheme,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (blocContext, state) {
            if (state is AuthenticationUninitialized) {
              return LoadingScreen(); // or splash screen
            } else if (state is AuthenticationAuthenticated) {
              return MultiProvider(providers: [
                Provider<TournamentsRepository>(
                    create: (_) => TournamentsRepository()),
              ], child: HomeScreen());
            } else if (state is AuthenticationUnauthenticated) {
              return LoginScreen(userRepository: widget.userRepository);
            } else {
              return LoadingScreen();
            }
          },
        ),
      ),
    );
  }
}
