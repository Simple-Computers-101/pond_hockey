// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/router/guard.dart';
import 'package:pond_hockey/screens/login/forget.dart';
import 'package:pond_hockey/screens/account/account.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/view_tournament.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/scoring/score_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_game.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/view_team.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/screens/tournaments/add_tournament/add_tournament.dart';
import 'package:pond_hockey/screens/tournaments/add_teams/add_teams.dart';

class Router {
  static const home = '/';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const account = '/account';
  static const tournaments = '/tournaments';
  static const tournamentDetails = '/tournament-details';
  static const scoreTournament = '/score-tournament';
  static const manageTournament = '/manage-tournament';
  static const manageGame = '/manage-game';
  static const teamDetails = '/team-details';
  static const addTournament = '/add-tournament';
  static const addTeams = '/add-teams';
  static const _guardedRoutes = {
    login: [UnAuthGuard],
    account: [AuthGuard],
    scoreTournament: [AuthGuard],
    manageTournament: [AuthGuard],
    manageGame: [AuthGuard],
    addTournament: [AuthGuard],
    addTeams: [AuthGuard],
  };
  static final navigator = ExtendedNavigator(_guardedRoutes);
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.home:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => HomeScreen(),
          settings: settings,
        );
      case Router.login:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => LoginScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.forgotPassword:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => ForgotPassword(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.account:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => AccountScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.tournaments:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TournamentsScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.tournamentDetails:
        if (hasInvalidArgs<Tournament>(args)) {
          return misTypedArgsRoute<Tournament>(args);
        }
        final typedArgs = args as Tournament;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              ViewTournament(tournament: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.scoreTournament:
        if (hasInvalidArgs<Tournament>(args)) {
          return misTypedArgsRoute<Tournament>(args);
        }
        final typedArgs = args as Tournament;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              ScoreTournament(tournament: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.manageTournament:
        if (hasInvalidArgs<Tournament>(args, isRequired: true)) {
          return misTypedArgsRoute<Tournament>(args);
        }
        final typedArgs = args as Tournament;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              ManageTournament(tournament: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.manageGame:
        if (hasInvalidArgs<Game>(args)) {
          return misTypedArgsRoute<Game>(args);
        }
        final typedArgs = args as Game;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              ManageGame(game: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.teamDetails:
        if (hasInvalidArgs<Team>(args)) {
          return misTypedArgsRoute<Team>(args);
        }
        final typedArgs = args as Team;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TeamDetailsScreen(team: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.addTournament:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AddTournamentScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      case Router.addTeams:
        if (hasInvalidArgs<Tournament>(args, isRequired: true)) {
          return misTypedArgsRoute<Tournament>(args);
        }
        final typedArgs = args as Tournament;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AddTeamsScreen(tournament: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 150),
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
