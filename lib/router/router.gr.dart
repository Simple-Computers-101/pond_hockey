// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:pond_hockey/initial_screen.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';
import 'package:pond_hockey/screens/tournaments/add_tournament/add_tournament.dart';

class Router {
  static const init = '/';
  static const home = '/home';
  static const login = '/login';
  static const tournaments = '/tournaments';
  static const addTournament = '/add-tournament';
  static const routes = [
    init,
    home,
    login,
    tournaments,
    addTournament,
  ];
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.init:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => InitialScreen(key: typedArgs),
          settings: settings,
        );
      case Router.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: settings,
        );
      case Router.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case Router.tournaments:
        if (hasInvalidArgs<TournamentsScreenArguments>(args)) {
          return misTypedArgsRoute<TournamentsScreenArguments>(args);
        }
        final typedArgs =
            args as TournamentsScreenArguments ?? TournamentsScreenArguments();
        return MaterialPageRoute(
          builder: (_) => TournamentsScreen(
              key: typedArgs.key,
              scoringMode: typedArgs.scoringMode,
              editMode: typedArgs.editMode),
          settings: settings,
        );
      case Router.addTournament:
        return MaterialPageRoute(
          builder: (_) => AddTournamentScreen(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//TournamentsScreen arguments holder class
class TournamentsScreenArguments {
  final Key key;
  final bool scoringMode;
  final bool editMode;
  TournamentsScreenArguments(
      {this.key, this.scoringMode = false, this.editMode = false});
}
