import 'package:flutter/material.dart';
import 'package:pond_hockey/router/guard.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';
import 'package:pond_hockey/services/email/email_helper.dart';
import 'package:pond_hockey/theme/style.dart';

void main() {
  Router.navigator.addGuards([AuthGuard()]);
  // EmailHelper().start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TournamentViewing(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pond Hockey',
        theme: Style().lightTheme,
        navigatorKey: Router.navigator.key,
        onGenerateRoute: Router.onGenerateRoute,
        initialRoute: Router.home,
      ),
    );
  }
}
