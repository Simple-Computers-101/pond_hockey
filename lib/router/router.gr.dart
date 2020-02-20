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

class Router {
  static const init = '/';
  static const home = '/home';
  static const login = '/login';
  static const tournaments = '/tournaments';
  static const routes = [
    init,
    home,
    login,
    tournaments,
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
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => TournamentsScreen(key: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
