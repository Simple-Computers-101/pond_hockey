import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pond_hockey/bloc/auth/auth_bloc.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:pond_hockey/theme/style.dart';
import 'package:provider/provider.dart';

void main() {
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
    return MultiProvider(
      providers: [
        Provider<TournamentsRepository>(
          create: (_) => TournamentsRepository(),
        ),
        Provider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (blocContext) {
          return AuthenticationBloc(
            userRepository: Provider.of<UserRepository>(
              blocContext,
              listen: false,
            ),
          );
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pond Hockey',
          theme: Style().lightTheme,
          navigatorKey: Router.navigatorKey,
          onGenerateRoute: Router.onGenerateRoute,
        ),
      ),
    );
  }
}
